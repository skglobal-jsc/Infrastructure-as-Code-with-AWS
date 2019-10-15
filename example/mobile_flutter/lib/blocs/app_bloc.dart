
import 'dart:async';
import 'dart:io';

import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:rxdart/rxdart.dart';

import '../models/user_info.dart';
import '../services/api.dart';
import '../services/cognito_sns_service.dart';
import '../services/definitions.dart';
import '../services/graphql_api/allUsers_api.dart';
import '../services/graphql_api/deleteUser_api.dart';
import '../services/storage_service.dart';

class AppBloc{
  final StorageService _storageService;
  final BaseCognitoService _cognitoService;

  String _nextToken = '';
  List<UserInfo> _listUser = [];

  AppBloc(this._cognitoService, this._storageService);

// subjects
  final BehaviorSubject<bool> _runningLogin = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<List<UserInfo>> _userInfoSubject = BehaviorSubject<List<UserInfo>>.seeded([]);
  final BehaviorSubject<bool> _loadingInfoSubject = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<String> _userAvatarSubject = BehaviorSubject<String>();

// triggers
  Future<bool> signUp(String code) async {
    _runningLogin.sink.add(true);

    if (code != null) {
      // await _cognitoService.signUp(code);
      await _cognitoService.login(AuthenticationDetails(username: 'binhbv@gmail.com', password: 'binhbv@gmail.com'));
      await _saveUserInfo();
      _runningLogin.sink.add(false);
      return true;
    }
    _runningLogin.sink.add(false);
    return false;
  }

  refreshList({bool reset = false}) async {
    if (_loadingInfoSubject.stream.value || (!reset && _nextToken == null))
      return;

    _loadingInfoSubject.sink.add(true);

    if (reset){
      _listUser = [];
      _nextToken = '';
    }

    AllUsers res;
    try {
      res = await queryUsers(AllUsersArguments(
          limit: 7,
          nextToken: _nextToken
        ));
    } catch (e) {
      _loadingInfoSubject.sink.add(false);
      return;
    }

    _nextToken = res.allUsers.nextToken;
    await for (var user in _fromAllUsersToUserInfo(res)){
      _listUser.add(user);
    }

    _userInfoSubject.sink.add(_listUser);

    _loadingInfoSubject.sink.add(false);
  }

  updateAvatar(File avatar) async {
    _loadingInfoSubject.sink.add(true);
    if (avatar != null) {
      final linkPicture = await uploadAvatar(FileInfo(file: avatar, field: 'file'));
      _cognitoService.updateAttributes([CognitoUserAttribute(name: 'picture', value: linkPicture)]);
      _userAvatarSubject.sink.add(linkPicture);
    }
    _loadingInfoSubject.sink.add(false);
  }

  deleteUser(UserInfo user) async {
    await mutationDeleteUser(DeleteUserArguments(userName: user.id));
    _listUser.remove(user);
    _userInfoSubject.sink.add(_listUser);
  }

// signals
  Stream<bool> get isRunningLogin => _runningLogin.stream;
  Stream<List<UserInfo>> get listUser => _userInfoSubject.stream;
  Stream<bool> get loadingInfo => _loadingInfoSubject.stream;
  Stream<String> get userAvatar => _userAvatarSubject.stream;

// public functions
  Future<bool> setup() async {
    // Reload all data from hard drive
    _storageService.loadAllInfo();
    // storageService.resetAllInfo();

    final isSignedIn = await _cognitoService.init();
    if (isSignedIn){
      await _saveUserInfo();
    }

    return isSignedIn;
  }

  LoginCognitoUrl getSNSLoginInfo(ProviderType type){
    return LoginCognitoUrl(
      type == ProviderType.FACEBOOK
        ? _cognitoService.snsDetails.cognitoUserPoolLoginFacebookUrl
        : _cognitoService.snsDetails.cognitoUserPoolLoginGoogleUrl,
      _cognitoService.snsDetails.cognitoUserPoolLoginRedirectUrl
    );
  }

  Future logoutApp() async {
    _storageService.resetAllInfo();
    _listUser = [];
    _nextToken = '';
    await _cognitoService.signOut();
  }

  helloUser([UserInfo user]) async {
    await helloToUser(user);
  }

  dispose() {
    _runningLogin.close();
    _userInfoSubject.close();
    _loadingInfoSubject.close();
    _userAvatarSubject.close();
  }

// private functions
  _saveUserInfo() async {
    final filter = FilterInput();
    filter.Name = SearchableAttribute.email;
    filter.Value = _cognitoService.email;
    filter.Type = SearchableType.EXTRACTLY;

    final res = await queryUsers(AllUsersArguments(
        filter: filter,
        limit: 1,
      ));

    final user = await _fromAllUsersToUserInfo(res, getAll:true).first;
    _storageService.setInfo<UserInfo>(
      user,
      hasSave: true
    );

    _userAvatarSubject.sink.add(user.avatar);
  }

  Stream<UserInfo> _fromAllUsersToUserInfo(AllUsers data, {bool getAll=false}) async* {
    for (var user in data.allUsers.items) {
      if (!getAll && user.Username == _cognitoService.userName)
        continue;

      String email;
      String avatar;
      for (var attribute in user.Attributes) {
        if (attribute.Name == 'email')
          email = attribute.Value;
        else if (attribute.Name == 'picture')
          avatar = attribute.Value;
      }

      yield UserInfo(
        id: user.Username,
        email: email,
        avatar: avatar,
        isAdmin: user.groups.length > 0
          ? user.groups.first.GroupName == 'Admin'
          : false
      );
    }
  }
}

class LoginCognitoUrl {
  final String loginUrl;
  final String redirectUrl;
  LoginCognitoUrl(this.loginUrl, this.redirectUrl);
}
