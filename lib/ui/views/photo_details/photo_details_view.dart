import 'dart:math';

import 'package:flutter/material.dart';
import 'package:historical_maps/core/entitles/image_entity.dart';
import 'package:historical_maps/core/services/maps_service.dart';
import 'package:historical_maps/core/services/shell_state_service.dart';
import 'package:historical_maps/ui/commons/colors.dart';
import 'package:historical_maps/ui/commons/enums.dart';
import 'package:historical_maps/ui/views/photo_details/photo_details_model.dart';
import 'package:historical_maps/ui/widgets/base_widget.dart';
import 'package:provider/provider.dart';

class PhotoDetailsView extends StatelessWidget {
  const PhotoDetailsView({Key? key, required this.imageId}) : super(key: key);
  final String imageId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: BaseWidget<PhotoDetailsModel>(
              model: PhotoDetailsModel(
                  mapService: Provider.of<MapService>(context)),
              onModelReady: (model) => model.getDetails(imageId),
              builder: (_, model, __) {
                return model.state == ViewState.busy
                    ? Container()
                    : CustomScrollView(
                        slivers: [
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _ImageHeader(
                              minHeight: 70,
                              maxHeight: MediaQuery.of(context).size.width,
                              image: model.image,
                            ),
                          ),
                          SliverList(delegate: SliverChildListDelegate([])),
                        ],
                      );
              }),
        ),
      ),
    );
  }
}

class _ImageHeader extends SliverPersistentHeaderDelegate {
  _ImageHeader({
    required this.minHeight,
    required this.maxHeight,
    this.image,
  });
  final double maxHeight;
  final double minHeight;
  final ImageEntity? image;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: maxHeight,
      color: kColorBackgroundDark,
      child: Stack(
        children: [
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
                      onTap:
                          Provider.of<ShellStateService>(context, listen: false)
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
    );
  }

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(_ImageHeader oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight;
  }
}
