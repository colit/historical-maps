import 'package:historical_maps/core/entitles/image_entity.dart';
import 'package:historical_maps/core/services/maps_service.dart';
import 'package:historical_maps/ui/commons/enums.dart';
import 'package:historical_maps/ui/view_models/base_model.dart';

class PhotoDetailsModel extends BaseModel {
  PhotoDetailsModel({required MapService mapService})
      : _mapService = mapService;

  final MapService _mapService;

  late List<ImageEntity> _images;

  late int _initPageIndex;

  List<ImageEntity> get images => _images;
  int get initPageIndex => _initPageIndex;

  Future<void> getDetails(String imageId) async {
    setState(ViewState.busy);
    _images = await _mapService.getImageForId(imageId);
    _initPageIndex = _images.lastIndexWhere((image) => image.id == imageId);
    setState(ViewState.idle);
  }
}
