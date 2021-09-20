import 'dart:async';

import '../../ui/commons/enums.dart';
import '../../core/entitles/startup_state.dart';

class StartupService {
  Stream<StartupState> get startupState => _startUpStateController.stream;
  final _startUpStateController = StreamController<StartupState>();

  void showPage(PageType page) {
    _startUpStateController.add(StartupState(page));
  }
}
