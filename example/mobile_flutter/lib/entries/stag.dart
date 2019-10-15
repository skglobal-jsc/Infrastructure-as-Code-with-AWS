import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/utils.dart' as util;
import '../entries/secret_stag.dart';
import '../main.dart';
import '../services/api_service.dart';
import '../services/cognito_sns_service.dart';
import '../services/definitions.dart';
import '../services/graphql_service.dart';
import '../services/storage_service.dart';

Future main() async {
  final prefs = await SharedPreferences.getInstance();
  // set up environment
  GetIt.instance.registerLazySingleton<PublishSubject<ErrorInfo>>(() => PublishSubject<ErrorInfo>());
  GetIt.instance.registerLazySingleton<StorageService>(() => StorageService());
  GetIt.instance.registerLazySingleton<BaseCognitoService>(() => CognitoService(
      CognitoUserPool(
        snsDetails.userPoolId,
        snsDetails.userPoolAppClientId,
        clientSecret: snsDetails.userPoolAppClientSecret,
        storage: CognitoStorageHelper(Storage(prefs)).getStorage(),
        ),
      snsDetails
    ));
  GetIt.instance.registerLazySingleton<BaseApiService>(() => ApiService(
    getValidToken: () async => await GetIt.instance<BaseCognitoService>().idToken,
    authority: apiEndpoint,
    subPath: "dev/",
    errorSubject: GetIt.instance<PublishSubject<ErrorInfo>>(),
    isHTTPS: true,
  ));
  GetIt.instance.registerLazySingleton<BaseGraphQLService>(() => GraphQLService(
    graphqlUrl: graphqlUrl,
    getToken: () async => await GetIt.instance<BaseCognitoService>().accessToken,
  ));
  return runApp(App(iosLocale: await util.iosLocale(),));
}
