import 'package:flutter/material.dart';

import 'routes/routes.dart';

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    print('parseRouteInformation: $uri');
    // TODO: Return correct path
    return StartupPath();
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    // if (configuration is FestivalPath) {
    //   return RouteInformation(location: '/festival');
    // }
    return null;
  }
}
