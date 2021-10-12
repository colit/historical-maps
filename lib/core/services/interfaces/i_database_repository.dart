import 'package:historical_maps/core/entitles/image_entity.dart';
import 'package:historical_maps/core/entitles/map_entity.dart';

abstract class IDatabaseRepository {
  Future<List<MapEntity>> getMaps();
  Future<String?> getMapURLForId(String id);

  Future<List<ImageEntity>> getImagesForMap(String id);
}
