import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:historical_maps/core/services/bottom_sheet_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../commons/map_icons.dart';
import '../../commons/enums.dart';
import '../../widgets/base_widget.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/maps_service.dart';
import 'map_library_widget.dart';
import 'map_model.dart';
import 'maps_toggle_button.dart';

class MapView extends StatelessWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapPath = Provider.of<MapService>(context).currentMapDataPath ?? '';
    return BaseWidget<MapModel>(
      model: MapModel(locationService: Provider.of<LocationService>(context)),
      onModelReady: (model) => model.registerController(MapController()),
      builder: (_, model, __) => model.state == ViewState.idle
          ? Scaffold(
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () => model.jumpToBase(),
                    child: const Icon(
                      MapIcons.iconDom,
                      size: 36,
                    ),
                    key: const Key('home'),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    onPressed: () => model.jumpToCurrentLocation(),
                    child: const Icon(Icons.gps_fixed),
                    key: const Key('position'),
                  ),
                ],
              ),
              body: Stack(
                children: [
                  FlutterMap(
                    mapController: model.mapController,
                    options: MapOptions(
                      center: LatLng(50.9383, 6.9581),
                      zoom: 16.0,
                      minZoom: 13.0,
                      maxZoom: 18.0,
                    ),
                    layers: [
                      model.showTodayMap
                          ? TileLayerOptions(
                              urlTemplate:
                                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: ['a', 'b', 'c'])
                          : TileLayerOptions(
                              tileProvider: const FileTileProvider(),
                              urlTemplate: "$mapPath{z}/{x}/{y}.png",
                            ),
                      MarkerLayerOptions(
                        markers: [
                          if (model.currentLocation != null)
                            Marker(
                              width: 25.0,
                              height: 25.0,
                              point: model.currentLocation!,
                              builder: (ctx) => CustomPaint(
                                painter: PositionMarker(),
                                size: const Size(40, 40),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () => Provider.of<BottomSheetService>(
                                    context,
                                    listen: false)
                                .showBottomSheet(MapsLibraryWidget()),
                            child: const Text('Karten'),
                          ),
                          Expanded(child: Container()),
                          MapsToggleButton(
                            callback: model.setMapView,
                            label: Provider.of<MapService>(context)
                                .currentMap
                                .year
                                .toString(),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          : Container(),
    );
  }
}

class PositionMarker extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint fill = Paint();

    fill.style = PaintingStyle.fill;
    fill.color = Colors.red;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, fill);

    fill.style = PaintingStyle.stroke;
    fill.color = Colors.white;
    fill.strokeWidth = 4;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
