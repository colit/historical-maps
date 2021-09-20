import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/shell_state_service.dart';
import '../../core/entitles/shell_state.dart';
import 'page_creator.dart';
import 'routes/routes.dart';

class ShellRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // UserService _userService;
  // set userService(UserService value) {
  //   _userService ??= value;
  // }

  @override
  Widget build(BuildContext context) {
    var pages = Provider.of<ShellState>(context).pages!;
    print('AppShell: rebuild ShellRouterDelegate with ${pages.length} pages');
    return Navigator(
      key: navigatorKey,
      // transitionDelegate: ShellTransitionDelegate(pages),
      pages: PageCreator.getPagesList(pages),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        Provider.of<ShellStateService>(context, listen: false).popPage();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    print('AppShell.setNewRoutePath: ${configuration.toString()}');
  }
}
