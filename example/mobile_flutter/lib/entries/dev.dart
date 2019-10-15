import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../helpers/utils.dart' as util;
import '../main.dart';
import '../mocks/mock_api_service.dart';
import '../mocks/mock_cognito_service.dart';
import '../mocks/mock_graphql_service.dart';
import '../services/api_service.dart';
import '../services/cognito_sns_service.dart';
import '../services/definitions.dart';
import '../services/graphql_service.dart';
import '../services/storage_service.dart';

Future main() async {
  // set up environment
  GetIt.instance.registerLazySingleton<PublishSubject<ErrorInfo>>(() => PublishSubject<ErrorInfo>());
  GetIt.instance.registerLazySingleton<StorageService>(() => StorageService());
  GetIt.instance.registerLazySingleton<BaseCognitoService>(() => MockCognitoService());
  GetIt.instance.registerLazySingleton<BaseApiService>(() => MockApiService(
    errorSubject: GetIt.instance<PublishSubject<ErrorInfo>>(),
  ));
  GetIt.instance.registerLazySingleton<BaseGraphQLService>(() => MockGraphQLService());
  return runApp(App(iosLocale: await util.iosLocale(),));
}
