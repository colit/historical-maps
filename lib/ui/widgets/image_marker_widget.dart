import 'package:flutter/material.dart';
import 'package:historical_maps/ui/commons/map_icons.dart';

class ImageMarkerWidget extends StatelessWidget {
  const ImageMarkerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.redAccent,
        boxShadow: [
          BoxShadow(
            color: Color(0x66000000),
            offset: Offset(0, 5),
            blurRadius: 6,
          ),
        ],
      ),
      child: const Icon(
        MapIcons.iconImage,
        color: Colors.white,
        size: 32,
      ),
    );
  }
}
