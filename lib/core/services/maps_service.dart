import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:historical_maps/core/entitles/loading_state_value.dart';
import 'package:historical_maps/ui/commons/enums.dart';
import 'package:http/http.dart' as http;

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

  final _loadingController = StreamController<LoadingValue>();
  Stream<LoadingValue> get loadingState => _loadingController.stream;

  String? get currentMapDataPath {
    return _currentMap.path;
  }

  bool setCurrentMap() {
    return true;
  }

  Future<void> initLocalMaps() async {
    final bytes = await rootBundle.load('assets/maps/1450.zip');
    final data =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    final pathToMap = await _extractFromArchive(data, 1450);
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

  void loadMap(MapEntity selectedMap) async {
    final id = selectedMap.id;
    _loadingController.add(
      LoadingValue(objectId: id, state: LoadingState.busy),
    );
    final url = await _databaseRepository.getMapURLForId(id);
    if (url == null) {
      _loadingController.add(
        LoadingValue(objectId: id, state: LoadingState.idle),
      );
      return;
    }
    print('download from $url');
    final response =
        await http.Client().send(http.Request('GET', Uri.parse(url)));
    final total = response.contentLength ?? 0;

    List<int> bytes = [];
    int received = 0;

    response.stream.listen((value) {
      bytes.addAll(value);
      received += value.length;
      _loadingController.add(LoadingValue(
        objectId: id,
        state: LoadingState.progress,
        value: received / total,
      ));
    }).onDone(() async {
      _loadingController.add(LoadingValue(
        objectId: id,
        state: LoadingState.busy,
      ));
      final data = Uint8List.fromList(bytes);
      final path = await _extractFromArchive(data, selectedMap.year);
      _loadingController.add(LoadingValue(
        objectId: id,
        state: LoadingState.idle,
      ));
      print('map saved to $path');
    });
  }

  Future<String> _extractFromArchive(Uint8List data, int year) async {
    final archive = ZipDecoder().decodeBytes(data);

    final localPath = await getApplicationDocumentsDirectory();
    final pathToMap = '${localPath.path}/$year/';
    print('create map on $pathToMap');

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
    return pathToMap;
  }
}
