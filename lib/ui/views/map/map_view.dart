import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:historical_maps/core/commons/parse_const.dart';
import 'package:historical_maps/core/services/bottom_sheet_service.dart';
import 'package:historical_maps/core/services/shell_state_service.dart';
import 'package:historical_maps/ui/commons/colors.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:proj4dart/proj4dart.dart' as proj4;

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

  List<double> getResolutions(double maxX, double minX, int zoom,
      [double tileSize = 256.0]) {
    var size = (maxX - minX) / tileSize;

    return List.generate(zoom, (z) => size / math.pow(2, z));
  }

  @override
  Widget build(BuildContext context) {
    // final Bounds<double> _bounds = Bounds<double>(
    //   const CustomPoint<double>(-1877994.66, 3932281.56),
    //   const CustomPoint<double>(836715.13, 9440581.95),
    // );
    // final epsg25832CRS = Proj4Crs.fromFactory(
    //   code: 'EPSG:25832',
    //   proj4Projection: proj4.Projection.add('EPSG:25832',
    //       '+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs'),
    //   resolutions: [
    //     4891.969810252,
    //     2445.984905126,
    //     1222.9924525616,
    //     611.4962262808,
    //     305.7481131404,
    //     152.87405657048,
    //     76.43702828524,
    //     38.21851414248,
    //     19.109257071296,
    //     9.554628535648,
    //     4.777314267824,
    //     2.388657133912,
    //     1.194328566956,
    //     0.597164283478
    //   ],
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
                      // crs: epsg25832CRS,
                      center: model.currentCenter,
                      zoom: model.currentZoom,
                      minZoom: 13.0,
                      maxZoom: 18.0,
                      onPositionChanged: (position, __) =>
                          model.updateMapPosition(position),
                    ),
                    children: [
                      TileLayerWidget(
                        options: TileLayerOptions(
                          backgroundColor: Colors.white,
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                          tileProvider: const CachedTileProvider(),
                          wmsOptions: model.showTodayMap
                              ? null
                              : WMSTileLayerOptions(
                                  // crs: epsg25832CRS,
                                  version: '1.3.0',
                                  baseUrl: ParseConstants.geoServerURL,
                                  layers: [model.mapReference]),
                        ),
                      ),
                      LocationMarkerLayerWidget(
                        options: LocationMarkerLayerOptions(
                            marker: const DefaultLocationMarker(
                                color: kColorMainRed)),
                      ),
                      MarkerLayerWidget(
                        options: MarkerLayerOptions(
                          markers: model.markers,
                          rotate: true,
                        ),
                      ),
                    ],
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: MapsToggleButton(
                              callback: model.setMapView,
                              label: model.year,
                              initWithHistoricalMap: !model.showTodayMap,
                            ),
                          ),
                          Expanded(child: Container()),
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
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(
                                  MapIcons.more,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
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

class CachedTileProvider extends TileProvider {
  const CachedTileProvider();
  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    return CachedNetworkImageProvider(
      getTileUrl(coords, options),
    );
  }
}
