import 'package:flutter/material.dart';
import 'package:historical_maps/core/entitles/image_entity.dart';
import 'package:historical_maps/ui/widgets/parse_image_widget.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({Key? key, required this.image}) : super(key: key);

  final ImageEntity image;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: InteractiveViewer(
        panEnabled: false,
        minScale: 1,
        maxScale: 6,
        child: Center(
          child: ParseImageWidget(
            key: ObjectKey(image.file),
            file: image.file,
            onReady: () => {},
          ),
        ),
      ),
    );
  }
}
