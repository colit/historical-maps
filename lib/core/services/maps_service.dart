import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:historical_maps/core/entitles/map_data.dart';

class MapService {
  late MapData _currentMap;
  List<MapData> _allMaps = [];

  void registerMap() {}

  MapData get currentMap => _currentMap;

  String? get currentMapDataPath {
    return _currentMap.path;
  }

  bool setCurrentMap() {
    return true;
  }

  void getMapsList() {}

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
    _currentMap = MapData(
      name: 'Köln im Mittelalter',
      year: 1450,
      path: pathToMap,
    );
    print('geladen: ${_currentMap.path}');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
