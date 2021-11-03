import 'package:historical_maps/core/entitles/image_entity.dart';
import 'package:historical_maps/core/entitles/map_entity.dart';
import 'package:historical_maps/core/entitles/map_referece.dart';

abstract class IDatabaseRepository {
  Future<List<MapEntity>> getMaps();
  Future<List<MapReference>> getMapReferences();

  Future<String?> getMapURLForId(String id);
  Future<List<ImageEntity>> getImagesForMap(String id);

  Future<ImageEntity?> getImageForId(String imageId);

  Future<List<ImageEntity>> getImagesForPOI(String pointOfInterestId);
}
