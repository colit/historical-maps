import 'package:flutter/material.dart';
import 'package:historical_maps/ui/views/photo_details/photo_details_view.dart';

import '../views/infos.dart';
import '../views/location_request/location_request_view.dart';
import '../views/map/map_view.dart';
import '../views/notes.dart';
import '../views/notifications_view.dart';
import '../views/onboarding_view.dart';
import '../views/startup/startup_view.dart';
import '../views/app_shell.dart';
import '../commons/enums.dart';
import '../../core/entitles/app_page.dart';
import 'fade_animation_project.dart';

class PageCreator {
  static List<Page> getPagesList(List<AppPage> pages) {
    var output = <Page>[];
    var index = 0;
    for (var page in pages) {
      output.add(getPage(page, index));
      index++;
    }
    return output;
  }

  static Page getPage(AppPage appPage, int index) {
    var type = appPage.type;
    var arguments = appPage.arguments;
    print('PageCreator.getPage($type)');
    Page output;
    switch (type) {
      case PageType.shell:
        output = FadeAnimationPage(
          key: appPage.key,
          child: const AppShell(),
        );
        break;
      // --------------------------
      case PageType.startup:
        output = FadeAnimationPage(
          key: appPage.key as LocalKey?,
          child: StartupView(
            shouldLoadData: arguments!.first,
          ),
        );
        break;
      case PageType.locationRequest:
        output = FadeAnimationPage(
          key: appPage.key as LocalKey?,
          child: const LocationRequestView(),
        );
        break;
      case PageType.onboarding:
        output = MaterialPage(
          key: appPage.key as LocalKey?,
          child: const OnboardingView(),
        );
        break;
      case PageType.notificationsRequest:
        output = MaterialPage(
          key: appPage.key as LocalKey?,
          child: const NotificationsView(),
        );
        break;
      case PageType.map:
        output = MaterialPage(
          key: appPage.key as LocalKey?,
          child: const MapView(),
        );
        break;
      case PageType.notes:
        output = MaterialPage(
          key: appPage.key as LocalKey?,
          child: const NotesView(),
        );
        break;
      case PageType.info:
        output = MaterialPage(
          key: appPage.key as LocalKey?,
          child: const InfosView(),
        );
        break;
      case PageType.photoDetails:
        output = MaterialPage(
          key: appPage.key as LocalKey?,
          child: PhotoDetailsView(
            imageId: arguments?.first,
          ),
        );
        break;

      default:
        throw Exception('error: undefined Page type $type');
    }
    return output;
  }
}
