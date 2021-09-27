import 'package:historical_maps/core/entitles/alert_action.dart';
import 'package:historical_maps/core/entitles/alert_message.dart';
import 'package:historical_maps/core/entitles/map_entity.dart';
import 'package:historical_maps/core/services/dialog_service.dart';
import 'package:historical_maps/core/services/maps_service.dart';
import 'package:historical_maps/ui/view_models/base_model.dart';

class MapLibraryModel extends BaseModel {
  MapLibraryModel(
      {required MapService mapService, required DialogService dialogService})
      : _mapService = mapService,
        _dialogService = dialogService {
    _mapServiceListenerId =
        mapService.registerNotifyer((_) => notifyListeners());
  }

  final MapService _mapService;
  final DialogService _dialogService;

  late int _mapServiceListenerId;

  List<MapEntity> get maps => _mapService.maps;

  void setCurrentMap(int index) {
    final selectedMap = maps[index];
    if (selectedMap.id != _mapService.currentMap.id) {
      if (selectedMap.isInstalled) {
        _mapService.setCurrentMap(selectedMap);
      } else {
        _dialogService.showDialog(
          AlertMessage(
            title: 'Karte ist nicht installiert',
            content: 'Soll die Karte runtergeaden und installiert werden?',
            actions: [
              AlertAction(
                  label: 'Ja',
                  action: () {
                    _mapService.loadMap(selectedMap);
                  }),
              AlertAction(label: 'Nein')
            ],
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _mapService.disposeListener(_mapServiceListenerId);
    super.dispose();
  }
}
