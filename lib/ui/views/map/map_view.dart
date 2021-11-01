import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:historical_maps/core/services/bottom_sheet_service.dart';
import 'package:historical_maps/core/services/shell_state_service.dart';
import 'package:historical_maps/ui/commons/colors.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
// import 'package:proj4dart/proj4dart.dart' as proj4;

import '../../../core/services/location_service.dart';
import '../../../core/services/maps_service.dart';
import '../../commons/map_icons.dart';
import '../../commons/enums.dart';
import '../../widgets/base_widget.dart';
import '../maps_library/map_library_widget.dart';
import 'map_model.dart';
import 'maps_toggle_button.dart';

class MapView extends StatelessWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var resolutions = <double>[
      32768,
      16384,
      8192,
      4096,
      2048,
      1024,
      512,
      256,
      128
    ];
    var maxZoom = (resolutions.length - 1).toDouble();

    // var epsg3413CRS = Proj4Crs.fromFactory(
    //   code: 'EPSG:3413',
    //   proj4Projection: proj4.Projection.add('EPSG:3413',
    //       '+proj=stere +lat_0=90 +lat_ts=70 +lon_0=-45 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs'),
    //   resolutions: resolutions,
    // );

    return BaseWidget<MapModel>(
      model: MapModel(
        locationService: Provider.of<LocationService>(context),
        mapService: Provider.of<MapService>(context),
        shellStateService: Provider.of<ShellStateService>(context),
      ),
      onModelReady: (model) => model.registerController(MapController()),
      builder: (_, model, __) => model.state == ViewState.idle
          ? Scaffold(
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () => model.jumpToBase(),
                    child: const Icon(
                      MapIcons.dom,
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
                      TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                        wmsOptions: model.showTodayMap
                            ? null
                            : WMSTileLayerOptions(
                                format: 'image/png',
                                baseUrl:
                                    'https://www.opendem.info/geoserver/histo/wms?',
                                layers: [
                                  model.mapReference,
                                ],
                              ),
                      ),
                      MarkerLayerOptions(
                        markers: model.markers,
                        rotate: true,
                        // ... [
                        //   if (model.currentLocation != null)
                        //     Marker(
                        //       width: 25.0,
                        //       height: 25.0,
                        //       point: model.currentLocation!,
                        //       builder: (ctx) => CustomPaint(
                        //         painter: PositionMarker(),
                        //         size: const Size(40, 40),
                        //       ),
                        //     ),
                        // ],
                      ),
                    ],
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => Provider.of<BottomSheetService>(
                                    context,
                                    listen: false)
                                .showBottomSheet(const MapsLibraryWidget()),
                            child: Container(
                              height: 40,
                              decoration: const BoxDecoration(
                                color: kColorMainRed,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.only(left: 15, right: 20),
                                child: Icon(
                                  MapIcons.more,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          // ElevatedButton(
                          //   onPressed: () => Provider.of<BottomSheetService>(
                          //           context,
                          //           listen: false)
                          //       .showBottomSheet(const MapsLibraryWidget()),
                          //   child: const Text('Karten'),
                          // ),
                          Expanded(child: Container()),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: MapsToggleButton(
                              callback: model.setMapView,
                              label: model.year,
                              initWithHistoricalMap: !model.showTodayMap,
                            ),
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
