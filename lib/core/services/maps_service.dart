import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:historical_maps/core/services/interfaces/i_database_repository.dart';
import 'package:historical_maps/core/entitles/map_entity.dart';

class MapService {
  MapService({required IDatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository;

  final IDatabaseRepository _databaseRepository;
  late MapEntity _currentMap;
  List<MapEntity> _maps = [];

  List<MapEntity> get maps => _maps;

  void registerMap() {}

  MapEntity get currentMap => _currentMap;

  String? get currentMapDataPath {
    return _currentMap.path;
  }

  bool setCurrentMap() {
    return true;
  }

  Future<void> initLocalMaps() async {
    final bytes = await rootBundle.load('assets/maps/1450.zip');
    final list =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    final archive = ZipDecoder().decodeBytes(list);

    final localPath = await _localPath;
    final pathToMap = localPath + '/1450/';

    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File(pathToMap + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        final dir = pathToMap + filename;
        Directory(dir).create(recursive: true);
      }
    }
    _currentMap = MapEntity(
      id: 'MAP_1450',
      name: 'Köln im Mittelalter',
      year: 1450,
      path: pathToMap,
      isRemovable: false,
    );
  }

  Future<void> getMapsList() async {
    final maps = await _databaseRepository.getMaps();
    _maps = [_currentMap, ...maps];
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
