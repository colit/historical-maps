import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/entitles/app_page.dart';
import '../../core/entitles/startup_state.dart';
import '../../ui/commons/enums.dart';
import 'page_creator.dart';
import 'routes/routes.dart';

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  late PageType currentBuildPage;
  PageType? lastBuildPage;

  @override
  Widget build(BuildContext context) {
    currentBuildPage = Provider.of<StartupState>(context).currentPage;
    var shouldLoadData = lastBuildPage != null;
    lastBuildPage = currentBuildPage;
    print('AppRouterDelegate.build()');
    return Navigator(
      pages: [
        MaterialPage(
          child: Navigator(
            key: navigatorKey,
            pages: PageCreator.getPagesList([
              AppPage(
                type: currentBuildPage,
                arguments: [shouldLoadData],
                key: UniqueKey(),
              )
            ]),
            onPopPage: (route, result) => route.didPop(result),
          ),
        ),
      ],
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    print('setNewRoutePath: $configuration');
  }
}
