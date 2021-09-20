import 'package:flutter/material.dart';

import '../../core/services/shell_state_service.dart';
import '../../ui/commons/destinations.dart';
import 'base_model.dart';

class BottomNavigationModel extends BaseModel {
  BottomNavigationModel(
      {required ShellStateService shellStateService,
      required List<String> labels})
      : _shellStateService = shellStateService,
        _navigationItems = [] {
    for (var i = 0; i < labels.length; i++) {
      _navigationItems.add(BottomNavigationBarItem(
          icon: kDestinations[i].icon!, label: labels[i]));
    }
  }

  final List<BottomNavigationBarItem> _navigationItems;

  List<BottomNavigationBarItem> get navigationItems => _navigationItems;

  final ShellStateService _shellStateService;

  void onItemTapped(int index) {
    _shellStateService.setShellPage(index);
  }
}
