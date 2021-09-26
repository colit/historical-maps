import 'package:historical_maps/ui/commons/enums.dart';

class LoadingValue {
  LoadingValue({this.objectId, this.state = LoadingState.idle, this.value = 0});
  final String? objectId;
  final LoadingState state;
  final double value;
}
