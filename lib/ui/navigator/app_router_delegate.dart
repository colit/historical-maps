import 'package:flutter/material.dart';
import 'package:historical_maps/core/services/gallery_service.dart';
import 'package:historical_maps/ui/managers/gallery_manager.dart';
import 'package:provider/provider.dart';

import '../../core/services/bottom_sheet_service.dart';
import '../../core/services/dialog_service.dart';
import '../../core/entitles/app_page.dart';
import '../../core/entitles/startup_state.dart';
import '../commons/enums.dart';
import '../managers/dialog_manager.dart';
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
    return Navigator(
      pages: [
        MaterialPage(
          child: GalleryManager(
            galleryService: Provider.of<GalleryService>(context),
            child: DialogManager(
              dialogService: Provider.of<DialogService>(context),
              bottomSheetService: Provider.of<BottomSheetService>(context),
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
