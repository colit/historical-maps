import 'package:historical_maps/core/exeptions/general_exeption.dart';
import 'package:historical_maps/core/services/location_service.dart';

import '../../../core/services/maps_service.dart';
import '../../../core/services/startup_service.dart';
import '../../../ui/commons/enums.dart';
import '../../../ui/view_models/base_model.dart';

class StartupModel extends BaseModel {
  StartupModel({
    required StartupService startupStateService,
    required MapService mapService,
    required LocationService locationService,
  })  : _startupStateService = startupStateService,
        _mapService = mapService,
        _locationService = locationService;

  final StartupService _startupStateService;
  final MapService _mapService;
  final LocationService _locationService;

  Future<void> initStartupState() async {
    // await _mapService.initLocalMaps();
    try {
      await _mapService.getGeoserverMaps();
      _startupStateService.showPage(await _locationService.isEnabled
          ? PageType.shell
          : PageType.locationRequest);
    } on GeneralExeption catch (e) {
      print(e.title);
      print(e.message);
    }
  }
}
