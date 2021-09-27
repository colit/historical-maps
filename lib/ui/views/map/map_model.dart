import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:historical_maps/core/services/location_service.dart';
import 'package:historical_maps/core/services/maps_service.dart';
import 'package:historical_maps/ui/view_models/base_model.dart';
import 'package:latlong2/latlong.dart';

class MapModel extends BaseModel {
  MapModel(
      {required LocationService locationService,
      required MapService mapService})
      : _locationService = locationService,
        _mapService = mapService {
    _locationService.registerStreamListener(updateCurrentLocation);
    _mapServiceListener = mapService.registerNotifyer((_) => notifyListeners());
  }

  bool _showTodayMap = false;
  bool get showTodayMap => _showTodayMap;

  final LocationService _locationService;
  final MapService _mapService;

  late int _mapServiceListener;

  Position? _currentLocation;
  LatLng? get currentLocation {
    if (_currentLocation != null) {
      return LatLng(_currentLocation!.latitude, _currentLocation!.longitude);
    } else {
      return null;
    }
  }

  late MapController _mapController;
  MapController get mapController => _mapController;

  String? get mapPath => _mapService.currentMap.path;

  get year => _mapService.currentMap.year.toString();

  jumpToBase() {
    // 50.9413° N, 6.9583° E
    _mapController.move(LatLng(50.9413, 6.9583), 17);
  }

  registerController(MapController mapController) {
    _mapController = mapController;
  }

  void updateCurrentLocation(currentLocation) {
    _currentLocation = currentLocation;
    notifyListeners();
  }

  void setMapView(bool showTodayMap) {
    _showTodayMap = showTodayMap;
    notifyListeners();
  }

  void jumpToCurrentLocation() {
    final currentLocation = _locationService.currentLocation;
    if (currentLocation != null) {
      final center =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      _mapController.move(center, 18);
    }
  }

  @override
  void dispose() {
    _locationService.pauseStreamListener();
    _mapService.disposeListener(_mapServiceListener);
    super.dispose();
  }
}
