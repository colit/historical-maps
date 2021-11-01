import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:historical_maps/parse_init_app.dart';

import 'providers.dart';
import 'ui/commons/colors.dart';
import 'ui/navigator/app_route_information_parser.dart';
import 'ui/navigator/app_router_delegate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ParseInitApp(app: HistoricalMapsApp()));
}

class HistoricalMapsApp extends StatelessWidget {
  const HistoricalMapsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Builder(
        builder: (context) => MaterialApp.router(
          title: 'Historische Kölner Stadtkarten',
          theme: themeData,
          routerDelegate: AppRouterDelegate(),
          routeInformationParser: AppRouteInformationParser(),
        ),
      ),
    );
  }
}
