
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/app_bloc.dart';
import '../widgets/routing.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    AppBloc bloc = Provider.of<AppBloc>(context, listen: false);
    bloc.setup().then(
      (isSignedIn) {
        if (isSignedIn) {
          Routing.navigate2(context, (_) => HomePage(), replace: true);
        } else {
          Routing.navigate2(context, (_) => LoginPage(), replace: true);
        }
      },
      onError: (error) {
        Routing.navigate2(context, (_) => LoginPage(), replace: true);
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('slash logo here'),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          ],
        ),
      ),
    );
  }

}
