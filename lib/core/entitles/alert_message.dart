import 'alert_action.dart';

class AlertMessage {
  AlertMessage({this.actions, this.title = '', this.content = ''});

  final String? title;
  final String? content;
  final List<AlertAction>? actions;
}
