import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'blocs/app_bloc.dart';
import 'localizations/app_localizations.dart';
import 'pages/splash_page.dart';
import 'services/cognito_sns_service.dart';
import 'services/storage_service.dart';

class App extends StatefulWidget {
  final Locale iosLocale;
  const App({Key key, @required this.iosLocale}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<AppBloc>(
      builder: (_) => AppBloc(
        GetIt.instance<BaseCognitoService>(),
        GetIt.instance<StorageService>(),
      ),
      dispose: (_, bloc) => bloc.dispose(),
      child: MaterialApp(
        localizationsDelegates: [
          const AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('vi', ''),
        ],
        localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {
          Locale candidateLocale = widget.iosLocale??locale;
          for (Locale lc in supportedLocales) {
            if (lc.languageCode == candidateLocale.languageCode) {
              return candidateLocale;
            }
          }
          return supportedLocales.first;
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashPage()
      ),
    );
  }
}
