import 'package:flutter/material.dart';
import '../commons/enums.dart';

class Destination {
  Destination({this.index, this.title, this.icon, this.pageType});
  final int? index;
  final String? title;
  final Icon? icon;
  final PageType? pageType;
}
