import 'package:async/async.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:historical_maps/core/entitles/image_entity.dart';
import 'package:historical_maps/core/services/location_service.dart';
import 'package:historical_maps/core/services/maps_service.dart';
import 'package:historical_maps/core/services/shell_state_service.dart';
import 'package:historical_maps/ui/commons/enums.dart';
import 'package:historical_maps/ui/view_models/base_model.dart';
import 'package:historical_maps/ui/views/map/image_marker.dart';
import 'package:historical_maps/ui/widgets/image_marker_widget.dart';
import 'package:latlong2/latlong.dart';

class MapModel extends BaseModel {
  MapModel(
      {required LocationService locationService,
      required MapService mapService,
      required ShellStateService shellStateService})
      : _locationService = locationService,
        _mapService = mapService,
        _shellStateService = shellStateService {
    _locationService.registerStreamListener(updateCurrentLocation);
    _mapServiceListener = mapService.registerNotifyer((_) {
      _showTodayMap = false;
      _updateImagesOnMap();
      notifyListeners();
    });
  }

  CancelableOperation _waitingFoIdleState = CancelableOperation.fromFuture(
    Future.delayed(const Duration()),
  );

  LatLng get currentCenter => _locationService.currentMapCenter;
  double get currentZoom => _locationService.currentMapZoom;

  bool _showTodayMap = false;
  bool get showTodayMap => _showTodayMap;

  final LocationService _locationService;
  final MapService _mapService;
  final ShellStateService _shellStateService;

  late int _mapServiceListener;

  late final _todaMarker =
      _mapService.todayImages.map(_markerBuilder).toList(growable: false);

  List<Marker> _markers = [];
  List<Marker> get markers => _showTodayMap ? _todaMarker : _markers;

  Position? _currentLocation;
  LatLng? get currentLocation => _currentLocation == null
      ? null
      : LatLng(_currentLocation!.latitude, _currentLocation!.longitude);

  late MapController _mapController;
  MapController get mapController => _mapController;

  String get mapReference => _mapService.currentMap.reference;

  get year => _mapService.currentMap.year.toString();

  jumpToBase() {
    // 50.9413° N, 6.9583° E
    _mapController.move(LatLng(50.9413, 6.9583), 17);
  }

  registerController(MapController mapController) {
    _mapController = mapController;
    _updateImagesOnMap();
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

  void _updateImagesOnMap() {
    final images = _mapService.imagesOnMap;
    _markers = images.map(_markerBuilder).toList(growable: false);
  }

  ImageMarker _markerBuilder(ImageEntity image) {
    return ImageMarker(
      anchorPos: AnchorPos.align(AnchorAlign.center),
      height: 34,
      width: 34,
      image: image,
      builder: (_) => ImageMarkerWidget(
        id: image.id,
        callback: (id) =>
            _shellStateService.pushPage(PageType.photoDetails, arguments: [id]),
      ),
    );
  }

  void updateMapPosition(MapPosition position) {
    _waitingFoIdleState.cancel();
    _waitingFoIdleState = CancelableOperation.fromFuture(
      Future.delayed(const Duration(milliseconds: 500)),
    ).then(
      (_) => _locationService.saveMapState(position.center, position.zoom),
    );
  }
}
