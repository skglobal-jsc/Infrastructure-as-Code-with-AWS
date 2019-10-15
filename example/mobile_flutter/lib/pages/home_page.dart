import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../blocs/app_bloc.dart';
import '../widgets/network_image.dart';
import '../widgets/popup_loading.dart';
import '../widgets/routing.dart';
import '../localizations/app_localizations.dart';
import '../models/user_info.dart';
import '../pages/login_page.dart';
import '../services/definitions.dart';
import '../services/storage_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<ErrorInfo> _errorInfoSub;
  ScrollController _controller;

  AppBloc _bloc;

  @override
  void initState() {
    super.initState();
    _errorInfoSub = GetIt.instance<PublishSubject<ErrorInfo>>().listen((errorInfo){
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(errorInfo.message),
          actions: <Widget>[
            FlatButton(
              child: Text(AppLocalizations.of(context).close),
              onPressed: Navigator.of(context).pop,
            ),
          ],
        ),
      );
    });

    _bloc = Provider.of<AppBloc>(context, listen: false);
    _bloc.refreshList();

    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.offset >= (_controller.position.maxScrollExtent + 50) &&
          _controller.position.outOfRange) {
        _bloc.refreshList();
        // print('Load more data');
      }
    });
  }

  @override
  void dispose() {
    _errorInfoSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          FlatButton(
            child: Text(
              'Reset',
              style: TextStyle(
                color: Colors.red
              ),
              ),
            onPressed: () {
              _bloc.refreshList(reset: true);
              _controller.jumpTo(0);
              },
            ),
          Spacer(),
          Text('Home'),
          Spacer(),
          FlatButton(
            child: Text('Logout'),
            onPressed: () async {
              await _bloc.logoutApp();
              await Routing.navigate2(
                context,
                (context) => LoginPage(),
                replace: true
                );
              },
            ),
        ],)
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          _buildListView(),
          StreamBuilder<bool>(
            stream: _bloc.loadingInfo,
            builder: (context, loading) {
              return loading.data != null && loading.data
                  ? PopupLoading(text: 'Loading ...')
                  : Container();
            }
          )
        ]
      )
    );
  }

  _buildListView(){
    final userInfo = GetIt.instance<StorageService>().getInfo<UserInfo>();
    return StreamBuilder<List<UserInfo>>(
      stream: _bloc.listUser,
      builder: (context, listUser) =>
        ListView(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            ),
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          controller: _controller,
          children: <Widget>[
            Container(
              height: 80,
              child: Row(children: <Widget>[
                GestureDetector(
                  onTap: () async => _bloc.updateAvatar(
                    await ImagePicker.pickImage(source: ImageSource.gallery)),
                  child: StreamBuilder(
                    stream: _bloc.userAvatar,
                    builder: (context, userAvatar) => CachedNetworkImage(
                      url: userAvatar.data,
                      width: 60,
                      height: null,
                      fit: BoxFit.contain
                  ))
                ),
                Container(width: 10,),
                Text(
                  userInfo.email,
                  maxLines: 2,
                  ),
                Spacer(),
                FlatButton(
                  child: Text('Hello all'),
                  onPressed: _bloc.helloUser,
                )
              ])
            ),
            Container(height: 10,),
            ..._buildListUser(userInfo.isAdmin, listUser.data??[])
          ],
        )
    );
  }

  Iterable<Widget> _buildListUser(bool userIsAdmin, List<UserInfo> listUser){
    return listUser.map((user) =>
      Container(
        height: 80,
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          child: Row(children: <Widget>[
            CachedNetworkImage(
              url: user.avatar,
              width: 50,
              height: 80,
              fit: BoxFit.contain
            ),
            Container(width: 10,),
            Text(
              user.email,
              maxLines: 2,
              ),
          ]),
          secondaryActions: <Widget>[
            FlatButton(
              child: Text('Say hello'),
              onPressed: () => _bloc.helloUser(user),
              ),
            ...(userIsAdmin
            ? [FlatButton(
                child: Text('Del user'),
                onPressed: () => _bloc.deleteUser(user),
              )]
            : [])
          ],
      ))
    );
  }
}
