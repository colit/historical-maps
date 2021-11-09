import 'package:flutter/material.dart';
import 'package:historical_maps/core/services/gallery_service.dart';
import 'package:historical_maps/ui/commons/colors.dart';
import 'package:historical_maps/ui/commons/ui_helpers.dart';

class GalleryManager extends StatefulWidget {
  const GalleryManager(
      {Key? key, required this.child, required GalleryService galleryService})
      : _galleryService = galleryService,
        super(key: key);
  final Widget child;
  final GalleryService _galleryService;
  @override
  _GalleryManagerState createState() => _GalleryManagerState();
}

class _GalleryManagerState extends State<GalleryManager> {
  late GalleryService galleryService;
  @override
  void initState() {
    super.initState();
    galleryService = widget._galleryService;
    galleryService.registerGalleryListener(_showGallery);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showGallery(content) {
    showDialog(
      barrierColor: kColorBackgroundDark.withAlpha(0xf0),
      context: context,
      useSafeArea: false,
      builder: (_) => Stack(
        children: [
          content,
          Positioned(
            left: 0,
            top: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceMedium),
                child: ClipOval(
                  child: Material(
                    color: Colors.black38, // button color
                    child: InkWell(
                      splashColor: Colors.black,
                      onTap: () {
                        galleryService.galleryComplete();
                        Navigator.of(context).pop();
                      }, // inkwell color
                      child: const SizedBox(
                        width: 48,
                        height: 48,
                        child: Icon(
                          Icons.close,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
