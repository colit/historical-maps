import 'package:graphql/client.dart';

import '../commons/graphql_queries.dart';
import '../entitles/map_data.dart';
import '../services/interfaces/i_database_repository.dart';

class MongoDatabaseRepository implements IDatabaseRepository {
  GraphQLClient? _client;
  GraphQLClient get client {
    return _client ??= GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(GraphQLQueries.graphqlAPI,
          defaultHeaders: GraphQLQueries.graphQLHeader),
    );
  }

  @override
  Future<List<MapEntity>> getMaps() async {
    List<MapEntity> output = [];
    return output;
  }
}
