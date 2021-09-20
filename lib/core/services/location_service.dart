import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LocationService {
  StreamSubscription<Position>? _positionStreamSubscription;

  Stream<Position> get positionStream => _positionStreamController.stream;
  final _positionStreamController = StreamController<Position>();

  void Function(Position)? _callbackLocationUpdate;

  Position? _currentPosition;

  Position? get currentLocation => _currentPosition;

  Future<bool> get isEnabled async {
    final serviceEnebled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnebled) {
      final permission = await Geolocator.checkPermission();
      return (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse);
    }
    return false;
  }

  Future<void> requestPermission() async {
    final permission = await Geolocator.requestPermission();
    // if (permission == LocationPermission.always ||
    //     permission == LocationPermission.whileInUse) {
    //   _positionStream =
    //       Geolocator.getPositionStream().listen(_positionListener);
    // }
  }

  Stream<Position> initPositionStrean() {
    _positionStreamSubscription =
        Geolocator.getPositionStream().listen(_positionListener);
    return _positionStreamController.stream;
  }

  // StreamSubscription?
  void registerStreamListener(void Function(Position) callback) {
    if (_positionStreamSubscription == null) {
      _positionStreamSubscription =
          Geolocator.getPositionStream().listen(_positionListener);
    } else {
      _positionStreamSubscription!.resume();
    }
    _callbackLocationUpdate = callback;
  }

  void pauseStreamListener() {
    _positionStreamSubscription?.pause();
  }

  void _positionListener(Position position) {
    _currentPosition = position;
    _positionStreamController.add(position);
    _callbackLocationUpdate?.call(position);
  }
}
