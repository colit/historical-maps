import 'package:flutter/material.dart';
import 'package:historical_maps/core/entitles/map_entity.dart';
import 'package:historical_maps/core/services/maps_service.dart';
import 'package:provider/provider.dart';

import 'map_item_library_widget.dart';

class MapsLibraryWidget extends StatefulWidget {
  const MapsLibraryWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<MapsLibraryWidget> createState() => _MapsLibraryWidgetState();
}

class _MapsLibraryWidgetState extends State<MapsLibraryWidget> {
  // [
  //   MapEntity(
  //     id: 'Karte von 1450',
  //     name: 'Karte von 1450',
  //     year: 1450,
  //   ),
  //   MapEntity(
  //     id: 'Karte von 1915',
  //     name: 'Karte von 1915',
  //     year: 1915,
  //   ),
  //   MapEntity(
  //     id: 'Karte von 1964',
  //     name: 'Karte von 1964',
  //     year: 1964,
  //   ),
  // ];

  final controller = PageController(
    viewportFraction: 0.35,
    initialPage: 0,
  );

  void _itemCallback(itemIndex) {
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
    final List<MapEntity> maps =
        Provider.of<MapService>(context, listen: false).maps;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 15),
        child: Column(
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
                itemCount: maps.length,
                onPageChanged: (index) {
                  print('new poage: $index');
                },
                itemBuilder: (context, index) => MapLibraryItemWidget(
                  index: index,
                  mapItem: maps[index],
                  callback: _itemCallback,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
