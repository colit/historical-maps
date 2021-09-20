import 'package:flutter/material.dart';
import '../../ui/commons/enums.dart';

class AppPage {
  AppPage({required this.type, this.key, this.arguments});

  AppPage copyWith({type, key, arguments}) {
    return AppPage(
        type: type ?? this.type,
        key: key ?? this.key,
        arguments: arguments ?? this.arguments);
  }

  final PageType type;
  final Key? key;
  final List<dynamic>? arguments;
}
