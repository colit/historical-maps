import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:historical_maps/core/commons/parse_const.dart';
import 'package:historical_maps/core/services/bottom_sheet_service.dart';
import 'package:historical_maps/core/services/shell_state_service.dart';
import 'package:historical_maps/ui/commons/colors.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

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
                        backgroundColor: Colors.white,
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                        wmsOptions: model.showTodayMap
                            ? null
                            : WMSTileLayerOptions(
                                baseUrl: ParseConstants.geoServerURL,
                                layers: [model.mapReference],
                              ),
                      ),
                      MarkerLayerOptions(
                        markers: model.markers,
                        rotate: true,
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
                                padding: EdgeInsets.only(left: 15, right: 20),
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
