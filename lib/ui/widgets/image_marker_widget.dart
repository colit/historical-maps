import 'package:flutter/material.dart';
import 'package:historical_maps/ui/commons/colors.dart';
import 'package:historical_maps/ui/commons/map_icons.dart';

class ImageMarkerWidget extends StatelessWidget {
  const ImageMarkerWidget({
    Key? key,
    required this.callback,
    required this.id,
  }) : super(key: key);

  final Function(String) callback;
  final String id;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callback.call(id),
      child: Container(
        decoration: const BoxDecoration(
          // border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: kColorDarkRed,
          boxShadow: [
            BoxShadow(
              color: Color(0x66000000),
              offset: Offset(0, 5),
              blurRadius: 6,
            ),
          ],
        ),
        child: const Icon(
          MapIcons.image,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
