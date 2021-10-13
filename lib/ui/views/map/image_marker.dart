import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:historical_maps/core/entitles/image_entity.dart';
import 'package:latlong2/latlong.dart';

class ImageMarker extends Marker {
  ImageMarker({
    required Widget Function(BuildContext) builder,
    required ImageEntity image,
    double? height,
    double? width,
    AnchorPos<dynamic>? anchorPos,
  })  : _image = image,
        super(
          builder: builder,
          point: LatLng(image.latitude, image.longitude),
          height: height ?? 30,
          width: width ?? 30,
          anchorPos: anchorPos,
          rotate: true,
        );
  final ImageEntity _image;

  ImageEntity get image => _image;
}
