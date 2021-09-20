import 'package:flutter/material.dart';
import 'package:historical_maps/core/services/location_service.dart';
import 'package:historical_maps/core/services/startup_service.dart';
import 'package:historical_maps/ui/commons/enums.dart';
import 'package:provider/provider.dart';

class LocationRequestView extends StatelessWidget {
  const LocationRequestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Text(
                    'Um deine Position auf den historischen Karten anzeigen zu können, benötigen wir Freigabe vom Standort deines Gerätes. Diese Daten speichern wir nicht und leiten sie nicht weiter.'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await Provider.of<LocationService>(context, listen: false)
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
        ),
      ),
    );
  }
}
