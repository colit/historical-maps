import 'package:flutter/material.dart';
import 'package:historical_maps/core/entitles/image_entity.dart';
import 'package:historical_maps/ui/commons/ui_helpers.dart';
import 'package:historical_maps/ui/widgets/parse_image_widget.dart';

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
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isReady ? 1 : 0,
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ParseImageWidget(
                key: ObjectKey(widget.image.file),
                file: widget.image.file,
                onReady: isReady
                    ? null
                    : () => Future.delayed(
                          Duration.zero,
                          () => setState(
                            () {
                              isReady = true;
                            },
                          ),
                        ),
              ),
              Padding(
                padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (widget.image.title != null)
                      Text(
                        widget.image.title!,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    if (widget.image.description != null)
                      Text(widget.image.description!,
                          style: const TextStyle(
                            height: 1.5,
                          )),
                    const SizedBox(height: 10),
                    if (widget.image.author != null) Text(widget.image.author!),
                    if (widget.image.source != null) Text(widget.image.source!),
                    if (widget.image.license != null)
                      Text(widget.image.license!),
                    UIHelper.verticalSpace(100),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
