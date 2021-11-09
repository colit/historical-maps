import 'package:flutter/material.dart';
import 'package:historical_maps/core/entitles/image_entity.dart';
import 'package:historical_maps/core/services/gallery_service.dart';
import 'package:historical_maps/ui/views/photo_details/image_preview.dart';
import 'package:historical_maps/ui/widgets/parse_image_widget.dart';
import 'package:provider/provider.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({Key? key, required this.image}) : super(key: key);

  final ImageEntity image;

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage>
    with AutomaticKeepAliveClientMixin<ImagePage> {
  bool isReady = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build;
    return GestureDetector(
      onTap: () =>
          Provider.of<GalleryService>(context, listen: false).showGallery(
        ImagePreview(
          image: widget.image,
        ),
      ),
      child: ParseImageWidget(
        key: ObjectKey(widget.image.file),
        file: widget.image.file,
        onReady: () => {},
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
