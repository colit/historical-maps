import 'dart:async';

import 'package:flutter/material.dart';

class GalleryService {
  late Function(Widget) _showGalleryListener;
  Completer? _dialogCompleter;

  void registerGalleryListener(Function(Widget) showDialogListener) {
    _showGalleryListener = showDialogListener;
  }

  Future showGallery(Widget content) {
    _dialogCompleter = Completer();
    _showGalleryListener(content);
    return _dialogCompleter!.future;
  }

  void galleryComplete() {
    _dialogCompleter!.complete();
    _dialogCompleter = null;
  }
}
