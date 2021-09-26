import 'parse_const.dart';

class GraphQLQueries {
  GraphQLQueries._();

  static Map<String, String> get graphQLHeader => {
        'X-Parse-Application-Id': ParseConstants.applicationId,
        'X-Parse-Master-Key': ParseConstants.parseMasterKey,
        'X-Parse-Client-Key': ParseConstants.clientKey,
      };

  static get graphqlAPI => '${ParseConstants.serverUrl}graphql';

  static const getMaps = r'''
    query getMaps{
      maps {
        edges{
          node {
            objectId,
            name,
            year
          }
        }
      }
    }
  ''';

  static const getMapUrlforId = r'''
    query getMapUrlforId($mapId: ID!) {
      map(id: $mapId) {
        data{
          url
        }
      }
    }
  ''';
}
