import 'dart:async';

import '../entitles/alert_message.dart';

class DialogService {
  late Function _showDialogListener;
  Completer? _dialogCompleter;

  void registerDialogListener(Function showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  Future showDialog(AlertMessage? message) {
    _dialogCompleter = Completer();
    _showDialogListener(message);
    return _dialogCompleter!.future;
  }

  void dialogComplete() {
    _dialogCompleter!.complete();
    _dialogCompleter = null;
  }
}
