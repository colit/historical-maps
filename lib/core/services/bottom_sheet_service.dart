import 'dart:async';

import 'package:flutter/material.dart';

class BottomSheetService {
  late Function _showBottomSheetListener;
  Completer? _bottomSheetCompleter;

  void registerBottomSheetListener(Function showBottomSheetListener) {
    _showBottomSheetListener = showBottomSheetListener;
  }

  Future showBottomSheet(Widget? child) {
    _bottomSheetCompleter = Completer();
    _showBottomSheetListener(child);
    return _bottomSheetCompleter!.future;
  }

  void bottomSheetComplete() {
    _bottomSheetCompleter!.complete();
    _bottomSheetCompleter = null;
  }
}
