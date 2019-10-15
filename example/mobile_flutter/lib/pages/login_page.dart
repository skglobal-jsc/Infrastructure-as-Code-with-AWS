
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/app_bloc.dart';
import '../widgets/popup_loading.dart';
import '../widgets/routing.dart';
import '../pages/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  _login(ProviderType type) async {
    final appBloc = Provider.of<AppBloc>(context);

    final url = appBloc.getSNSLoginInfo(type);

    final code = await Routing.navigate2<String>(
        context,
        (context) =>
          SNSSignInPage(
            loginUrl: url.loginUrl,
            redirectUrl: url.redirectUrl,
        ),
    );

    final isSignedIn = await appBloc.signUp(code);
    if (isSignedIn) {
      Routing.navigate2(context, (context) => HomePage(), replace: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppBloc bloc = Provider.of<AppBloc>(context, listen: false);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(image: AssetImage('assets/Icon-sk-global.png'), height: 150),
                  SizedBox(height: 50),
                  _signInButton(
                    "assets/google_logo.png",
                    'Sign in with Google',
                    () => _login(ProviderType.GOOGLE)),
                  SizedBox(height: 20),
                  _signInButton(
                    'assets/f_logo_RGB-Blue_250.png',
                    'Sign in with Facebook',
                    () => _login(ProviderType.FACEBOOK)),
                ],
              ),
            ),
            StreamBuilder(
              stream: bloc.isRunningLogin,
              builder: (context, snapshot) {
                return snapshot.data != null && snapshot.data
                  ? PopupLoading(text: 'Logging you in ...',)
                  : Container();
              },
            )
          ]
        ),
      ),
    );
  }

  Widget _signInButton(String asset, String text, Function onPressed) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage(asset), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
