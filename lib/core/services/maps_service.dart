import 'dart:async';

import 'package:historical_maps/core/commons/app_constants.dart';
import 'package:historical_maps/core/entitles/image_entity.dart';
import 'package:historical_maps/core/entitles/map_referece.dart';
import 'package:historical_maps/core/entitles/loading_state_value.dart';
import 'package:historical_maps/core/services/base_service.dart';
import 'package:historical_maps/core/services/interfaces/i_database_repository.dart';
import 'package:historical_maps/core/services/interfaces/i_persistent_repository.dart';
import 'package:historical_maps/core/entitles/map_entity.dart';

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
    _databaseRepository
        .getImagesForMap(AppConstants.todayMapId)
        .then((value) => _todayImages = value);
  }

  final IDatabaseRepository _databaseRepository;
  final IPersistentRepository _persistentRepository;

  // final _port = ReceivePort();
  late MapReference _currentMap;
  List<MapReference> _maps = [];
  List<ImageEntity> _imagesOnMap = [];
  late final List<ImageEntity> _todayImages;

  List<MapReference> get maps => _maps;
  List<ImageEntity> get imagesOnMap => _imagesOnMap;
  List<ImageEntity> get todayImages => _todayImages;

  MapReference get currentMap => _currentMap;
  int get currentMapIndex =>
      _maps.indexOf(_maps.firstWhere((e) => e.id == _currentMap.id));

  final _loadingController = StreamController<LoadingValue>();
  Stream<LoadingValue> get loadingState => _loadingController.stream;

  String? get currentMapKey {
    return _currentMap.key;
  }

  Future<void> setCurrentMap(MapReference selectedMap) async {
    final selectedMapId = selectedMap.id;
    _currentMap = selectedMap;
    _imagesOnMap = await _databaseRepository.getImagesForMap(selectedMapId);
    notifyListeners(argument: selectedMapId);
  }

  Future<void> getGeoserverMaps() async {
    _maps = await _databaseRepository.getMapReferences();
    _maps.sort((m1, m2) => m1.year.compareTo(m2.year));
    setCurrentMap(_maps.first);
  }

  Future<List<ImageEntity>> getImageForId(String imageId) async {
    final image = await _databaseRepository.getImageForId(imageId);
    if (image != null) {
      return image.pointOfInterestId == null
          ? [image]
          : await _databaseRepository.getImagesForPOI(image.pointOfInterestId!);
    } else {
      return [];
    }
  }
}


// Future<void> initLocalMaps() async {
  //   const mapId = AppConstants.initMapId;
  //   const file = AppConstants.initMapFileName;
  //   String? localPath = await _persistentRepository.getString(mapId);
  //   if (localPath == null) {
  //     final bytes = await rootBundle.load('assets/maps/$file');
  //     final data =
  //         bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  //     localPath = await _extractFromArchive(data, file, mapId);
  //     await _persistentRepository.setString(mapId, localPath);
  //   }
  //   _currentMap = MapEntity(
  //     id: AppConstants.initMapId,
  //     name: AppConstants.initMapDescription,
  //     year: 1450,
  //     file: file,
  //     localPath: localPath,
  //     isRemovable: false,
  //   );
  //   _loadingController.add(
  //     LoadingValue(
  //       objectId: _currentMap.id,
  //       state: LoadingState.idle,
  //     ),
  //   );
  //   _getImagesForMap(_currentMap.id);
  // }


  // Future<void> getMapsList() async {
  //   final maps = await _databaseRepository.getMaps();
  //   for (final map in maps) {
  //     map.localPath = await _persistentRepository.getString(map.id);
  //   }
  //   _maps = [_currentMap, ...maps];
  // }

  // Future<void> loadMap(MapEntity selectedMap) async {
  //   final url = AppConstants.pathToMaps + selectedMap.file;
  //   var fileStream =
  //       DefaultCacheManager().getFileStream(url, withProgress: true);
  //   fileStream.listen((event) async {
  //     switch (event.runtimeType) {
  //       case DownloadProgress:
  //         final progress = (event as DownloadProgress).progress ?? 0;
  //         _loadingController.add(
  //           LoadingValue(
  //             objectId: selectedMap.id,
  //             state: LoadingState.progress,
  //             value: progress,
  //           ),
  //         );
  //         break;
  //       case FileInfo:
  //         final file = (event as FileInfo).file;

  //         final bytes = await file.readAsBytes();
  //         final localPath = await _extractFromArchive(
  //             bytes, selectedMap.file, selectedMap.id);
  //         await _persistentRepository.setString(selectedMap.id, localPath);
  //         _loadingController.add(
  //           LoadingValue(
  //             objectId: selectedMap.id,
  //             state: LoadingState.idle,
  //           ),
  //         );
  //         selectedMap.localPath = localPath;
  //         _currentMap = selectedMap;
  //         if (_currentMap.localPath != null) {
  //           _persistentRepository.setString(
  //               _currentMap.id, _currentMap.localPath!);
  //         }
  //         DefaultCacheManager().removeFile(file.basename);
  //         notifyListeners(argument: selectedMap.id);
  //         _getImagesForMap(selectedMap.id);
  //         break;
  //     }
  //   });
  // }

  // Future<String> _extractFromArchive(
  //     Uint8List data, String fileName, String mapId) async {
  //   final archive = ZipDecoder().decodeBytes(data);

  //   final localPath = await getApplicationDocumentsDirectory();
  //   final shortName = fileName.split('.').first;
  //   final pathToMap = '${localPath.path}/$shortName/';

  //   final totalFiles = archive.where((e) => e.isFile).length;
  //   int counter = 0;
  //   for (final file in archive) {
  //     final name = file.name;
  //     if (file.isFile) {
  //       final data = file.content as List<int>;
  //       final newFile = File(pathToMap + name);
  //       await newFile.create(recursive: true);
  //       await newFile.writeAsBytes(data);
  //       counter++;
  //       _loadingController.add(
  //         LoadingValue(
  //             objectId: mapId,
  //             state: LoadingState.install,
  //             value: counter / totalFiles),
  //       );
  //     } else {
  //       final dir = pathToMap + name;
  //       Directory(dir).create(recursive: true);
  //     }
  //   }
  //   return pathToMap;
  // }