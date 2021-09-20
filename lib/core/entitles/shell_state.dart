import 'app_page.dart';

class ShellState {
  ShellState({this.pages, this.currentShellIndex});
  final List<AppPage>? pages;
  final int? currentShellIndex;
}
