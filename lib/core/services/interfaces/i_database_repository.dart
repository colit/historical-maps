import 'package:historical_maps/core/entitles/map_data.dart';

abstract class IDatabaseRepository {
  Future<List<MapEntity>> getMaps();
}
