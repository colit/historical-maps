import 'package:flutter/material.dart';
import 'package:historical_maps/core/services/location_service.dart';
import 'package:provider/provider.dart';

import '../../../core/services/maps_service.dart';
import '../../../core/services/startup_service.dart';
import '../../views/startup/startup_model.dart';
import '../../widgets/base_widget.dart';
import '../../commons/colors.dart';
import 'splash_image_widget.dart';

class StartupView extends StatelessWidget {
  const StartupView({Key? key, required this.shouldLoadData}) : super(key: key);

  final bool shouldLoadData;
  @override
  Widget build(BuildContext context) {
    return shouldLoadData
        ? Scaffold(
            backgroundColor: kColorBackground,
            body: BaseWidget<StartupModel>(
              model: StartupModel(
                startupStateService: Provider.of<StartupService>(context),
                mapService: Provider.of<MapService>(context),
                locationService: Provider.of<LocationService>(context),
              ),
              onModelReady: (model) => model.initStartupState(),
              builder: (_, model, __) => Stack(
                children: const [
                  SplashImageWidget(),
                  Center(
                    child: Text('loading...'),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
