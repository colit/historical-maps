import 'package:async/async.dart';
import 'package:flutter/material.dart';
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
  late PageController _pageController;

  int _currentPageIndex = 0;

  List<ImageEntity> get images => _images;
  int get initPageIndex => _initPageIndex;
  ImageEntity get currentImage => _images[_currentPageIndex];
  PageController get pageController => _pageController;

  bool get isFirst => _currentPageIndex == 0;
  bool get isLast => _currentPageIndex == _images.length - 1;

  CancelableOperation? cancelable;

  Future<void> getDetails(String imageId) async {
    setState(ViewState.busy);
    cancelable = CancelableOperation.fromFuture(
      _mapService.getImageForId(imageId),
    )..then((responce) {
        _images = responce;
        _initPageIndex = _images.lastIndexWhere((image) => image.id == imageId);
        _currentPageIndex = _initPageIndex;
        _pageController = PageController(initialPage: _initPageIndex);
        setState(ViewState.idle);
      });
  }

  void setCurrentPage(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }

  void goBack() {
    _pageController.animateToPage(_currentPageIndex - 1,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void goForward() {
    _pageController.animateToPage(_currentPageIndex + 1,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  void dispose() {
    final isBusy = !(cancelable?.isCompleted ?? true);
    if (isBusy) {
      cancelable?.cancel();
    }
    super.dispose();
  }
}
