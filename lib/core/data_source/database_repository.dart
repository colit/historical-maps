import 'package:graphql/client.dart';
import 'package:historical_maps/core/exeptions/general_exeption.dart';

import '../commons/graphql_queries.dart';
import '../entitles/map_entity.dart';
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
    var output = <MapEntity>[];

    final options = QueryOptions(
      document: gql(GraphQLQueries.getMaps),
    );

    final result = await client.query(options);

    if (result.hasException) {
      throw GeneralExeption(
          title: 'graphQL Exception', message: result.exception.toString());
    } else {
      final nodes = List<MapEntity>.from(result.data?['maps']['edges']
          .map((node) => MapEntity.fromGraphQL(node['node'])));
      output += nodes;
    }

    return output;
  }
}
