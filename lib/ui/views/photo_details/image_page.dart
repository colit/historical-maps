import 'package:flutter/material.dart';
import 'package:historical_maps/core/entitles/image_entity.dart';
import 'package:historical_maps/ui/commons/ui_helpers.dart';
import 'package:historical_maps/ui/widgets/parse_image_widget.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({Key? key, required this.image}) : super(key: key);

  final ImageEntity image;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ParseImageWidget(
          file: image.file,
        ),
        Padding(
          padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (image.title != null)
                Text(
                  image.title!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              if (image.description != null)
                Text(image.description!,
                    style: const TextStyle(
                      height: 1.5,
                    )),
              const SizedBox(height: 10),
              if (image.author != null) Text(image.author!),
              if (image.yearPublished != null)
                Text(image.yearPublished!.toString()),
              if (image.source != null) Text(image.source!),
              if (image.license != null) Text(image.license!),
            ],
          ),
        ),
      ],
    );
  }
}
