import 'dart:convert';

import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseCognitoService {
  AuthenticationSNSDetails snsDetails;

  Future<String> get idToken;
  Future<String> get accessToken;
  Future<AWSCredentials> get credentials;
  String get email;
  String get userName;
  Future<Map<String,dynamic>> get userAttributes;

  Future<bool> init();
  Future<bool> signUp(String code);
  Future<bool> login(AuthenticationDetails authen);
  Future<void> signOut();
  updateAttributes(List<CognitoUserAttribute> attributes);
}

class CognitoService extends BaseCognitoService {
  final CognitoUserPool _userPool;
  CognitoUser _cognitoUser;
  CognitoUserSession _session;
  CognitoCredentials _cognitoCredentials;
  AWSCredentials _credentials;

  final AuthenticationSNSDetails snsDetails;

  CognitoService(this._userPool, this.snsDetails);

  /// Initiate user session from local storage if present
  Future<bool> init() async {
    _cognitoUser = await _userPool.getCurrentUser();
    if (_cognitoUser == null) {
      return false;
    }
    _session = await _cognitoUser.getSession();

    return _session?.isValid();
  }

  Future<CognitoUserSession> get _currentSession async {
    if (!_session.isValid()){
      _session = await _cognitoUser.refreshSession(_session.refreshToken);
    }

    return _session;
  }

  Future<String> get idToken async => (await _currentSession).idToken.jwtToken;
  Future<String> get accessToken async => (await _currentSession).idToken.jwtToken;

  /// Retrieve user credentials -- for use with other AWS services
  Future<AWSCredentials> get credentials async {
    if (_credentials != null && DateTime.now().millisecondsSinceEpoch < _cognitoCredentials.expireTime - 60000 ){
      return _credentials;
    }

    if (_cognitoUser == null || _session == null) {
      return null;
    }

    if (_cognitoCredentials == null)
      _cognitoCredentials = new CognitoCredentials(snsDetails.identityPoolId, _userPool);

    await _cognitoCredentials.getAwsCredentials(await idToken);
    _credentials = AWSCredentials(
      _cognitoCredentials.accessKeyId,
      _cognitoCredentials.sessionToken,
      _cognitoCredentials.secretAccessKey,
    );
    return _credentials;
  }

  String get email => _session.idToken.payload['email'];
  String get userName => _session.idToken.payload['cognito:username'];
  Future<Map<String,dynamic>> get userAttributes async => Map.fromIterable(
        await _cognitoUser.getUserAttributes(),
        key: (attribute) => attribute.getName(),
        value: (attribute) => attribute.getValue(),
      );

  /// Sign up new user
  Future<bool> signUp(String code) async {
    // User name makeshift, it will be replace by IdToken.payload['cognito:username']
    final cognitoUser = new CognitoUser(
      'user-abc', _userPool,
      storage: _userPool.storage
    );

    await cognitoUser.authenticateBySnsCode(
      code: code,
      redirectUrl: snsDetails.cognitoUserPoolLoginRedirectUrl,
      cognitoUserPoolTokenUrl: snsDetails.cognitoUserPoolTokenUrl,
    );
    return await init();
  }

  Future<bool> login(AuthenticationDetails authen) async {
    final cognitoUser = new CognitoUser(
      authen.username, _userPool,
      storage: _userPool.storage
    );

    await cognitoUser.authenticateUser(authen);
    return await init();
  }

  Future<void> signOut() async {
    if (_cognitoUser != null) {
      await _cognitoUser.signOut();
    }
    _credentials = null;
    _cognitoCredentials = null;
    _session = null;
    _cognitoUser = null;
  }

  updateAttributes(List<CognitoUserAttribute> attributes) {
    _cognitoUser.updateAttributes(attributes);
  }
}

class AWSCredentials {
  final String accessKeyId;
  final String sessionToken;
  final String secretAccessKey;
  AWSCredentials(
    this.accessKeyId,
    this.sessionToken,
    this.secretAccessKey,
  );
}

class Storage extends CognitoStorage {
  SharedPreferences _prefs;
  Storage(this._prefs);

  @override
  Future getItem(String key) async {
    String item;
    try {
      item = json.decode(_prefs.getString(key));
    } catch (e) {
      return null;
    }
    return item;
  }

  @override
  Future setItem(String key, value) async {
    _prefs.setString(key, json.encode(value));
    return getItem(key);
  }

  @override
  Future removeItem(String key) async {
    final item = getItem(key);
    if (item != null) {
      _prefs.remove(key);
      return item;
    }
    return null;
  }

  @override
  Future<void> clear() async {
    for (var key in _prefs.getKeys()) {
      if (key.startsWith('CognitoIdentityServiceProvider'))
        await removeItem(key);
    }
  }
}
