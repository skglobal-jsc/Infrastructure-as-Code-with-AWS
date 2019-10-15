
import 'package:graphql/client.dart';
import 'package:graphql/internal.dart';
import "package:gql/language.dart";

import '../services/graphql_api/allUsers_api.dart';
import '../services/graphql_service.dart';

class MockGraphQLService extends BaseGraphQLService {
  @override
  Future<QueryResult> mutate(MutationOptions options) {
    // TODO: implement mutate
    return null;
  }

  @override
  Future<QueryResult> query(QueryOptions options) async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (options.document == printNode(AllUsersQuery().document)) {
      return QueryResult(
        data: {
          "allUsers": {
            "items": [
              {
                "Attributes":[{"Name":"sub","Value":"d44edafb-53f0-45ea-bb13-88b02a6d3c3e"},{"Name":"email","Value":"hahaha@gmail.com"}],
                "Username":"d44edafb-53f0-45ea-bb13-88b02a6d3c3e"
              },
              {
                "Attributes":[{"Name":"sub","Value":"dfdcf5f6-236c-4135-a131-52ee488aa885"},{"Name":"email","Value":"hihihi@gmail.com"}],
                "Username":"dfdcf5f6-236c-4135-a131-52ee488aa885"
              }
            ],
            "nextToken":null
          }
        },
        source: QueryResultSource.Cache
      );
    }
    return null;
  }

  @override
  Stream<FetchResult> subscribe(Operation operation) {
    // TODO: implement subscribe
    return null;
  }

  @override
  ObservableQuery watchQuery(WatchQueryOptions options) {
    // TODO: implement watchQuery
    return null;
  }

}
