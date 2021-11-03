import 'package:flutter/material.dart';
import 'package:historical_maps/core/services/location_service.dart';
import 'package:historical_maps/core/services/startup_service.dart';
import 'package:historical_maps/ui/commons/enums.dart';
import 'package:historical_maps/ui/commons/ui_helpers.dart';
import 'package:historical_maps/ui/views/startup/splash_image_widget.dart';
import 'package:provider/provider.dart';

class LocationRequestView extends StatelessWidget {
  const LocationRequestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          const SplashImageWidget(),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceMedium),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(220),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Wrap(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          bottom: 15,
                          top: 20,
                        ),
                        child: Text(
                          'Um deine Position auf der Karte anzeigen zu können, benötigen wir Freigabe vom Standort deines Gerätes. Diese Daten speichern wir nicht und leiten sie nicht weiter.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await Provider.of<LocationService>(context,
                                  listen: false)
                              .requestPermission();
                          Provider.of<StartupService>(context, listen: false)
                              .showPage(PageType.shell);
                        },
                        child: const Text('Klar, bin dabei!'),
                      ),
                      TextButton(
                        onPressed: () {
                          Provider.of<StartupService>(context, listen: false)
                              .showPage(PageType.shell);
                        },
                        child: const Text('Vielleicht später'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Padding(
  //       padding: const EdgeInsets.all(15.0),
  //       child: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             const Padding(
  //               padding: EdgeInsets.only(bottom: 15),
  //               child: Text(
  //                   'Um deine Position auf den historischen Karten anzeigen zu können, benötigen wir Freigabe vom Standort deines Gerätes. Diese Daten speichern wir nicht und leiten sie nicht weiter.'),
  //             ),
  //             ElevatedButton(
  //               onPressed: () async {
  //                 await Provider.of<LocationService>(context, listen: false)
  //                     .requestPermission();
  //                 Provider.of<StartupService>(context, listen: false)
  //                     .showPage(PageType.shell);
  //               },
  //               child: const Text('Klar, bin dabei!'),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Provider.of<StartupService>(context, listen: false)
  //                     .showPage(PageType.shell);
  //               },
  //               child: const Text('Vielleicht später'),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
