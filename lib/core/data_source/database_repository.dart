import 'package:graphql/client.dart';
import 'package:historical_maps/core/commons/app_constants.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import '../entitles/image_entity.dart';
import '../entitles/map_referece.dart';
import '../entitles/parse_image.dart';
import '../exeptions/general_exeption.dart';
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
  Future<List<MapReference>> getMapReferences() async {
    var output = <MapReference>[];

    final options = QueryOptions(
      document: gql(GraphQLQueries.getMapReferences),
    );

    final result = await client.query(options);

    if (result.hasException) {
      throw GeneralExeption(
          title: 'graphQL Exception', message: result.exception.toString());
    } else {
      output = List<MapReference>.from(result.data?['mapReferences']['edges']
          .map((node) => MapReference.fromGraphQL(node['node'])));
    }

    return output;
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

  @override
  Future<String?> getMapURLForId(id) async {
    String? url;
    final options = QueryOptions(
      document: gql(GraphQLQueries.getMapUrlforId),
      variables: {
        'mapId': id,
      },
    );

    final result = await client.query(options);

    if (result.hasException) {
      throw GeneralExeption(
          title: 'graphQL Exception', message: result.exception.toString());
    } else {
      url = result.data?['map']?['url'];
    }

    return url;
  }

  @override
  Future<List<ImageEntity>> getImagesForMap(String id) async {
    final output = <ImageEntity>[];
    late QueryBuilder queryImage;

    if (id == AppConstants.todayMapId) {
      queryImage = QueryBuilder<ParseImage>(ParseImage())
        ..whereEqualTo('map', null);
    } else {
      final queryMap = QueryBuilder<ParseObject>(ParseObject('MapReference'))
        ..whereEqualTo('objectId', id);
      queryImage = QueryBuilder<ParseImage>(ParseImage())
        ..whereMatchesQuery('map', queryMap);
    }

    final response = await queryImage.query();

    if (response.success) {
      final results = response.result;
      if (results != null) {
        for (final ParseImage result in results) {
          output.add(ImageEntity.fromMap(result.map));
        }
      }
    }

    return output;
  }

  @override
  Future<ImageEntity?> getImageForId(String imageId) async {
    ImageEntity? output;
    final queryImage = QueryBuilder<ParseImage>(ParseImage())
      ..whereEqualTo(ImageEntity.keyObjectId, imageId);
    final response = await queryImage.query();
    if (response.success) {
      final results = response.results;
      if (results != null) {
        output = ImageEntity.fromMap((results.first as ParseImage).map);
        print('POI Id: ${output.pointOfInterestId}');
      }
    }

    return output;
  }

  @override
  Future<List<ImageEntity>> getImagesForPOI(String id) async {
    final output = <ImageEntity>[];
    final queryPOI = QueryBuilder<ParseObject>(ParseObject('PointOfInterest'))
      ..whereEqualTo('objectId', id);
    final queryImage = QueryBuilder<ParseImage>(ParseImage())
      ..whereMatchesQuery(ImageEntity.keyPointOfInterest, queryPOI);
    final response = await queryImage.query();
    if (response.success) {
      final results = response.results;
      if (results != null) {
        for (final result in results) {
          output.add(ImageEntity.fromMap((result as ParseImage).map));
        }
      }
    }
    return output;
  }
}
