
import 'package:graphql/client.dart';
import 'package:graphql/internal.dart';

abstract class BaseGraphQLService {

  ObservableQuery watchQuery(WatchQueryOptions options);

  Future<QueryResult> query(QueryOptions options);

  Future<QueryResult> mutate(MutationOptions options);

  Stream<FetchResult> subscribe(Operation operation);
}

class GraphQLService extends BaseGraphQLService {
  final GraphQLClient _client;

  GraphQLService({String graphqlUrl, GetToken getToken}):
    this._client = GraphQLClient(
      cache: InMemoryCache(),
      link: AuthLink(getToken: getToken,)
        .concat(HttpLink(uri: graphqlUrl,)),
    );

  ObservableQuery watchQuery(WatchQueryOptions options) => _client.watchQuery(options);

  Future<QueryResult> query(QueryOptions options) => _client.query(options);

  Future<QueryResult> mutate(MutationOptions options) => _client.mutate(options);

  Stream<FetchResult> subscribe(Operation operation) => _client.subscribe(operation);
}
