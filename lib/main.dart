import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:historical_maps/parse_init_app.dart';

import 'providers.dart';
import 'ui/commons/colors.dart';
import 'ui/navigator/app_route_information_parser.dart';
import 'ui/navigator/app_router_delegate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterDownloader.initialize(debug: true);
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
          theme: ThemeData(
            primaryColor: kColorBackgroundDark,
            tabBarTheme: const TabBarTheme(
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 2, color: Colors.white)),
            ),
          ),
          routerDelegate: AppRouterDelegate(),
          routeInformationParser: AppRouteInformationParser(),
        ),
      ),
    );
  }
}
