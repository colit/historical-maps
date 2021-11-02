import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:historical_maps/core/entitles/shell_state.dart';
import '../../core/entitles/app_page.dart';
import '../../ui/commons/enums.dart';
import '../../ui/commons/destinations.dart';

class ShellStateService {
  ShellStateService() {
    _currentShellIndex = 0;
    _currentStack = [
      AppPage(type: kDestinations[0].pageType!),
    ];
    // _shellMap[_currentShellIndex] = [
    //   AppPage(type: kDestinations[_currentShellIndex].pageType),
    // ];
  }

  static int getShellPageIndex(PageType pageType) {
    switch (pageType) {
      case PageType.map:
        return 0;
      case PageType.notes:
        return 1;
      case PageType.info:
        return 2;
      default:
        return 0;
    }
  }

  final _shellStateController = StreamController<ShellState>();

  Stream<ShellState> get shellState => _shellStateController.stream;

  // final Map<int, List<AppPage>> _shellMap = {};

  late int _currentShellIndex;
  var _currentStack = <AppPage>[];

  void setShellPage(int shellIndex) {
    if (shellIndex == _currentShellIndex && _currentStack.length == 1) return;
    final pageType = kDestinations[shellIndex].pageType;
    if (pageType != null) {
      _currentStack = [AppPage(type: pageType, key: UniqueKey())];
      _currentShellIndex = shellIndex;
      reloadAllPages();
    }
  }

  void pushPage(PageType pageType, {List? arguments}) {
    _currentStack
        .add(AppPage(type: pageType, arguments: arguments, key: UniqueKey()));
    _currentShellIndex = ShellStateService.getShellPageIndex(pageType);
    reloadAllPages();
  }

  void goBackTo(PageType type) {
    final stack = _currentStack;
    final index = stack.indexWhere((element) => element.type == type);
    if (index > 0) {
      stack.removeRange(index + 1, stack.length);
      _currentStack = stack;
    }
    reloadAllPages();
  }

  void popPage() {
    _currentStack.removeLast();
    _currentShellIndex =
        ShellStateService.getShellPageIndex(_currentStack.last.type);
    reloadAllPages();
  }

  void reloadAllPages() {
    _shellStateController.add(ShellState(
        pages: _currentStack, currentShellIndex: _currentShellIndex));
  }

  void replaceCurrentPage(PageType pageType, {List? arguments}) {
    _currentStack.removeLast();
    _currentStack
        .add(AppPage(type: pageType, arguments: arguments, key: UniqueKey()));
    reloadAllPages();
  }
}
