import 'package:historical_maps/core/entitles/map_entity.dart';

abstract class IDatabaseRepository {
  Future<List<MapEntity>> getMaps();
}
