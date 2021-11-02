import 'package:historical_maps/core/entitles/map_referece.dart';
import 'package:historical_maps/core/services/maps_service.dart';
import 'package:historical_maps/ui/view_models/base_model.dart';

class MapLibraryModel extends BaseModel {
  MapLibraryModel({required MapService mapService}) : _mapService = mapService {
    _mapServiceListenerId = mapService.registerNotifyer((id) {
      _loadingState[id] = true;
      notifyListeners();
    });
    _mapInFocus = _mapService.currentMap.name;
  }

  final MapService _mapService;

  late int _mapServiceListenerId;

  final Map<String, bool> _loadingState = {};

  List<MapReference> get maps => _mapService.maps;

  String get mapInFocus => _mapInFocus;
  late String _mapInFocus;

  void setCurrentMap(int index) {
    final selectedMap = maps[index];
    if (selectedMap.id != _mapService.currentMap.id) {
      _mapService.setCurrentMap(selectedMap);
    }
  }

  @override
  void dispose() {
    _mapService.disposeListener(_mapServiceListenerId);
    super.dispose();
  }

  void setMapInFocus(int index) {
    _mapInFocus = maps[index].name;
    notifyListeners();
  }
}
