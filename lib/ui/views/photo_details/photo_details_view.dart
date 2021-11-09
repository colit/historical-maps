import 'package:flutter/material.dart';
import 'package:historical_maps/core/entitles/image_entity.dart';
import 'package:historical_maps/core/services/maps_service.dart';
import 'package:historical_maps/core/services/shell_state_service.dart';
import 'package:historical_maps/ui/commons/colors.dart';
import 'package:historical_maps/ui/commons/enums.dart';
import 'package:historical_maps/ui/commons/ui_helpers.dart';
import 'package:historical_maps/ui/views/photo_details/photo_details_model.dart';
import 'package:historical_maps/ui/widgets/base_widget.dart';
import 'package:historical_maps/ui/widgets/pagination_button_next.dart';
import 'package:provider/provider.dart';

import 'image_page.dart';

class PhotoDetailsView extends StatelessWidget {
  const PhotoDetailsView({Key? key, required this.imageId}) : super(key: key);
  final String imageId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          BaseWidget<PhotoDetailsModel>(
            model:
                PhotoDetailsModel(mapService: Provider.of<MapService>(context)),
            onModelReady: (model) => model.getDetails(imageId),
            builder: (_, model, __) {
              List<ImageEntity> images = [];
              if (model.state == ViewState.idle) {
                images = model.images;
              }
              return images.isEmpty
                  ? const SafeArea(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        PageView.builder(
                          controller: model.pageController,
                          itemCount: images.length,
                          itemBuilder: (context, index) => ImagePage(
                            key: ValueKey(index),
                            image: images[index],
                          ),
                          onPageChanged: (index) => model.setCurrentPage(index),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (!model.isFirst)
                              PaginationButtonNext(
                                type: PaginationButtonType.left,
                                onTap: () => model.goBack(),
                              ),
                            Expanded(child: Container()),
                            if (!model.isLast)
                              PaginationButtonNext(
                                type: PaginationButtonType.right,
                                onTap: () => model.goForward(),
                              ),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withAlpha(0),
                                  Colors.black.withAlpha(220)
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: UIHelper.kHorizontalSpaceMedium,
                                  vertical: UIHelper.kHorizontalSpaceLarge),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  UIHelper.verticalSpaceLarge(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal:
                                            UIHelper.kHorizontalSpaceSmall),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: kColorMainRed,
                                    ),
                                    child: Text(
                                      model.currentImage.yearPublished
                                          .toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  UIHelper.verticalSpaceSmall(),
                                  if (model.currentImage.title != null)
                                    Text(
                                      model.currentImage.title!,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  if (model.currentImage.description != null)
                                    Text(model.currentImage.description!,
                                        style: const TextStyle(
                                            height: 1.5, color: Colors.white)),
                                  const SizedBox(height: 10),
                                  if (model.currentImage.author != null)
                                    Text(model.currentImage.author!,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  if (model.currentImage.source != null)
                                    Text(model.currentImage.source!,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  if (model.currentImage.license != null)
                                    Text(model.currentImage.license!,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    );
            },
          ),
          Positioned(
            left: 0,
            top: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: UIHelper.kVerticalSpaceMedium),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(24),
                      bottomRight: Radius.circular(24)),
                  child: Material(
                    color: Colors.black38, // button color
                    child: InkWell(
                      splashColor: Colors.black,
                      onTap:
                          Provider.of<ShellStateService>(context, listen: false)
                              .popPage, // inkwell color
                      child: const SizedBox(
                        height: 48,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: UIHelper.kHorizontalSpaceMedium),
                          child: Icon(
                            Icons.arrow_back,
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
          ),
        ],
      ),
    );
  }
}
