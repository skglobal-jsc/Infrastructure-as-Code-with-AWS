
import 'package:get_it/get_it.dart';
import 'package:graphql/client.dart';
import "package:gql/language.dart";
import 'package:path/path.dart' as path;

import '../models/user_info.dart';
import '../services/api_service.dart';
import '../services/definitions.dart';
import '../services/graphql_api/allUsers_api.dart';
import '../services/graphql_api/deleteUser_api.dart';
import '../services/graphql_service.dart';

Future<String> uploadAvatar(FileInfo file) async {
  final apiService = GetIt.instance<BaseApiService>();
  var requestParams = await apiService.get<Map<String, dynamic>>(
    apiUrl: 'upload',
    header: {
      'x-amz-meta-filekey': file.file.path.split('/').last
    },
    parser: (map) => map,
    needToken: true,
  );
  requestParams['fields']['Content-Type'] = 'image/${path.extension(file.file.path)}';

  var fileUrl = await apiService.uploadToUri<String>(
    uri: Uri.parse(requestParams['url']),
    parser: (map) => map['location'],
    files: [file],
    fields: Map.from(requestParams['fields']),
    parserHeader: true
  );

  return fileUrl;
}

Future helloToUser(UserInfo user) {
  return GetIt.instance<BaseApiService>().post(
    apiUrl: "hello",
    header: {"Content-Type": "application/json"},
    body: {
      "message": "Hello",
      ... user != null
        ? user.toJson()
        : {}
    },
    parser: (map) => null,
    needToken: true,
  );
}

Future<AllUsers> queryUsers(AllUsersArguments args) async {
  final query = AllUsersQuery(variables: args);

  final result = await GetIt.instance<BaseGraphQLService>().query(QueryOptions(
    document: printNode(query.document),
    variables: query.variables.toJson(),
    pollInterval: 4,
    errorPolicy: ErrorPolicy.all,
    fetchPolicy: FetchPolicy.cacheAndNetwork
    ));

  if (result.hasErrors && !result.errors[0].message.startsWith('Failed host lookup')) {
    print(result.errors);
    throw Exception(result.errors[0].message);
  }

  if (result.data == null) {
    return null;
  }

  return query.parse(Map.from(result.data));
}

Future<DeleteUser> mutationDeleteUser(DeleteUserArguments args) async {
  final query = DeleteUserQuery(variables: args);

  final result = await GetIt.instance<BaseGraphQLService>().mutate(MutationOptions(
    document: printNode(query.document),
    variables: query.variables.toJson(),
    errorPolicy: ErrorPolicy.all,
    ));

  if (result.hasErrors && !result.errors[0].message.startsWith('Failed host lookup')) {
    print(result.errors);
    throw Exception(result.errors[0].message);
  }

  if (result.data == null) {
    return null;
  }

  return query.parse(Map.from(result.data));
}
