import 'package:flutter/material.dart';
import 'package:historical_maps/core/entitles/image_entity.dart';
import 'package:historical_maps/core/services/maps_service.dart';
import 'package:historical_maps/core/services/shell_state_service.dart';
import 'package:historical_maps/ui/commons/colors.dart';
import 'package:historical_maps/ui/commons/enums.dart';
import 'package:historical_maps/ui/commons/ui_helpers.dart';
import 'package:historical_maps/ui/views/photo_details/photo_details_model.dart';
import 'package:historical_maps/ui/widgets/base_widget.dart';
import 'package:historical_maps/ui/widgets/pagination_widget.dart';
import 'package:provider/provider.dart';

import 'image_page.dart';

class PhotoDetailsView extends StatelessWidget {
  const PhotoDetailsView({Key? key, required this.imageId}) : super(key: key);
  final String imageId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorMainRed,
      body: SafeArea(
        child: Container(
          color: kColorBackground,
          child: Stack(
            children: [
              BaseWidget<PhotoDetailsModel>(
                model: PhotoDetailsModel(
                    mapService: Provider.of<MapService>(context)),
                onModelReady: (model) => model.getDetails(imageId),
                builder: (_, model, __) {
                  List<ImageEntity> images = [];
                  if (model.state == ViewState.idle) {
                    images = model.images;
                  }
                  return images.isEmpty
                      ? Container()
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            Wrap(
                              direction: Axis.vertical,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: PageView.builder(
                                    controller: model.pageController,
                                    itemCount: images.length,
                                    itemBuilder: (context, index) => ImagePage(
                                      key: ValueKey(index),
                                      image: images[index],
                                    ),
                                    onPageChanged: (index) =>
                                        model.setCurrentPage(index),
                                  ),
                                )
                              ],
                            ),
                            if (images.length > 1)
                              Positioned(
                                bottom: 0,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            kColorBackground.withAlpha(0),
                                            kColorBackground,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(
                                          UIHelper.kVerticalSpaceMedium),
                                      child: PaginationWidget(
                                        year: model.currentImage.yearPublished
                                            .toString(),
                                        onBackward: model.isFirst
                                            ? null
                                            : () => model.goBack(),
                                        onForward: model.isLast
                                            ? null
                                            : () => model.goForward(),
                                      ),
                                    ),
                                  ],
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
                    padding: const EdgeInsets.all(15),
                    child: ClipOval(
                      child: Material(
                        color: Colors.black38, // button color
                        child: InkWell(
                          splashColor: Colors.black,
                          onTap: Provider.of<ShellStateService>(context,
                                  listen: false)
                              .popPage, // inkwell color
                          child: const SizedBox(
                            width: 48,
                            height: 48,
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
            ],
          ),
        ),
      ),
    );
  }
}
