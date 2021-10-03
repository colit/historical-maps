import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:historical_maps/core/commons/app_constants.dart';
import 'package:historical_maps/core/entitles/loading_state_value.dart';
import 'package:historical_maps/core/services/base_service.dart';
import 'package:historical_maps/core/services/interfaces/i_database_repository.dart';
import 'package:historical_maps/core/services/interfaces/i_persistent_repository.dart';
import 'package:historical_maps/core/entitles/map_entity.dart';

import 'package:historical_maps/ui/commons/enums.dart';

class LoadingObject {
  LoadingObject(String temporaryPath, this.map)
      : _temporaryPath = temporaryPath;
  final String _temporaryPath;
  final MapEntity map;

  String get path => '$_temporaryPath/${map.file}';
}

class MapService extends BaseService {
  MapService({
    required IDatabaseRepository databaseRepository,
    required IPersistentRepository persistentRepository,
  })  : _databaseRepository = databaseRepository,
        _persistentRepository = persistentRepository {
    final reg = IsolateNameServer.registerPortWithName(
        _port.sendPort, AppConstants.downloaderSendPort);
    if (!reg) {
      IsolateNameServer.removePortNameMapping(AppConstants.downloaderSendPort);
      IsolateNameServer.registerPortWithName(
          _port.sendPort, AppConstants.downloaderSendPort);
    }
    _port.listen(_listener);
    FlutterDownloader.registerCallback(_downloadCallback);
  }

  final IDatabaseRepository _databaseRepository;
  final IPersistentRepository _persistentRepository;

  final _port = ReceivePort();
  late MapEntity _currentMap;
  List<MapEntity> _maps = [];

  List<MapEntity> get maps => _maps;

  MapEntity get currentMap => _currentMap;
  int get currentMapIndex =>
      _maps.indexOf(_maps.firstWhere((e) => e.id == _currentMap.id));

  final _loadingController = StreamController<LoadingValue>();
  Stream<LoadingValue> get loadingState => _loadingController.stream;

  final Map<String, LoadingObject> _loadingTasks = {};

  String? get currentMapDataPath {
    return _currentMap.localPath;
  }

  void setCurrentMap(MapEntity selectedMap) {
    _currentMap = selectedMap;
    notifyListeners();
  }

  Future<void> initLocalMaps() async {
    const mapId = 'MAP_1450';
    const file = '1450.zip';
    String? localPath = await _persistentRepository.getString(mapId);
    if (localPath == null) {
      final bytes = await rootBundle.load('assets/maps/$file');
      final data =
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      localPath = await _extractFromArchive(data, file, mapId);
      await _persistentRepository.setString(mapId, localPath);
    }
    _currentMap = MapEntity(
      id: 'MAP_1450',
      name: 'Köln im Mittelalter',
      year: 1450,
      file: file,
      localPath: localPath,
      isRemovable: false,
    );
  }

  Future<void> getMapsList() async {
    final maps = await _databaseRepository.getMaps();
    for (final map in maps) {
      map.localPath = await _persistentRepository.getString(map.id);
    }
    _maps = [_currentMap, ...maps];
  }

  Future<void> loadMap(MapEntity selectedMap) async {
    final url = AppConstants.pathToMaps + selectedMap.file;
    final temporaryPath = await getTemporaryDirectory();
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: temporaryPath.path,
      showNotification:
          false, // show download progress in status bar (for Android)
      openFileFromNotification:
          false, // click on notification to open downloaded file (for Android)
    );
    if (taskId != null) {
      _loadingTasks[taskId] = LoadingObject(temporaryPath.path, selectedMap);
    }
  }

  Future<void> _listener(dynamic data) async {
    String taskId = data[0];
    DownloadTaskStatus status = data[1];
    int progress = data[2];
    final loadingObject = _loadingTasks[taskId];
    if (loadingObject != null) {
      if (status == DownloadTaskStatus.running) {
        _loadingController.add(
          LoadingValue(
            objectId: loadingObject.map.id,
            state: LoadingState.progress,
            value: progress / 100,
          ),
        );
      } else if (status == DownloadTaskStatus.complete) {
        _loadingController.add(
          LoadingValue(
            objectId: loadingObject.map.id,
            state: LoadingState.install,
          ),
        );
        final bytes = File(loadingObject.path).readAsBytesSync();
        final localPath = await _extractFromArchive(
            bytes, loadingObject.map.file, loadingObject.map.id);
        await _persistentRepository.setString(loadingObject.map.id, localPath);
        print('file saved to: $localPath');
        _loadingController.add(
          LoadingValue(
            objectId: loadingObject.map.id,
            state: LoadingState.idle,
          ),
        );
        loadingObject.map.localPath = localPath;
        _currentMap = loadingObject.map;
        if (_currentMap.localPath != null) {
          _persistentRepository.setString(
              _currentMap.id, _currentMap.localPath!);
        }
        notifyListeners();
      }
    }
  }

  Future<String> _extractFromArchive(
      Uint8List data, String fileName, String mapId) async {
    final archive = ZipDecoder().decodeBytes(data);

    final localPath = await getApplicationDocumentsDirectory();
    final shortName = fileName.split('.').first;
    final pathToMap = '${localPath.path}/$shortName/';

    final totalFiles = archive.where((e) => e.isFile).length;
    int counter = 0;
    for (final file in archive) {
      final name = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        final newFile = File(pathToMap + name);
        await newFile.create(recursive: true);
        await newFile.writeAsBytes(data);
        counter++;
        _loadingController.add(
          LoadingValue(
              objectId: mapId,
              state: LoadingState.install,
              value: counter / totalFiles),
        );
      } else {
        final dir = pathToMap + name;
        Directory(dir).create(recursive: true);
      }
    }
    return pathToMap;
  }

  static void _downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? port =
        IsolateNameServer.lookupPortByName(AppConstants.downloaderSendPort);
    port?.send([id, status, progress]);
  }
}
