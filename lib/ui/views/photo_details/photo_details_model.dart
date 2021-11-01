import 'package:historical_maps/core/entitles/image_entity.dart';
import 'package:historical_maps/core/services/maps_service.dart';
import 'package:historical_maps/ui/commons/enums.dart';
import 'package:historical_maps/ui/view_models/base_model.dart';

class PhotoDetailsModel extends BaseModel {
  PhotoDetailsModel({required MapService mapService})
      : _mapService = mapService;

  final MapService _mapService;

  late ImageEntity? _image;

  ImageEntity? get image => _image;

  Future<void> getDetails(String imageId) async {
    setState(ViewState.busy);
    _image = await _mapService.getImageForId(imageId);
    setState(ViewState.idle);
  }
}
