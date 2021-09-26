import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/dialog_service.dart';
import '../../../core/services/maps_service.dart';
import '../../widgets/base_widget.dart';
import 'map_item_library_widget.dart';
import 'map_library_model.dart';

class MapsLibraryWidget extends StatefulWidget {
  const MapsLibraryWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<MapsLibraryWidget> createState() => _MapsLibraryWidgetState();
}

class _MapsLibraryWidgetState extends State<MapsLibraryWidget> {
  final controller = PageController(
    viewportFraction: 0.35,
    initialPage: 0,
  );

  void _animateToIndex(int itemIndex) {
    if (itemIndex != controller.page) {
      controller.animateToPage(
        itemIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCirc,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 15),
        child: BaseWidget<MapLibraryModel>(
            model: MapLibraryModel(
                mapService: Provider.of<MapService>(context),
                dialogService: Provider.of<DialogService>(context)),
            builder: (_, model, __) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'Historische Kölner Stadkarten',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: PageView.builder(
                      controller: controller,
                      itemCount: model.maps.length,
                      onPageChanged: (index) {
                        // some actions on page change...
                      },
                      itemBuilder: (context, index) => MapLibraryItemWidget(
                        index: index,
                        mapItem: model.maps[index],
                        callback: (index) {
                          _animateToIndex(index);
                          model.setCurrentMap(index);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
