import 'package:flutter/material.dart';
import 'package:historical_maps/core/entitles/loading_state_value.dart';
import 'package:historical_maps/core/entitles/map_referece.dart';
import 'package:historical_maps/core/services/maps_service.dart';
import 'package:historical_maps/ui/commons/enums.dart';
import 'package:provider/provider.dart';

class MapLibraryItemWidget extends StatelessWidget {
  const MapLibraryItemWidget({
    Key? key,
    required this.mapItem,
    required int index,
    Function(int)? callback,
  })  : _callback = callback,
        _index = index,
        super(key: key);

  final MapReference mapItem;
  final Function(int)? _callback;
  final int _index;

  @override
  Widget build(BuildContext context) {
    final isSelected =
        mapItem.id == Provider.of<MapService>(context).currentMap.id;
    return Consumer<LoadingValue>(builder: (context, state, child) {
      final isLoading =
          (state.objectId == mapItem.id && state.state != LoadingState.idle);
      return GestureDetector(
        onTap: () => _callback?.call(_index),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                mapItem.year.toString(),
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              color: isSelected ? Colors.amber.withAlpha(100) : Colors.white,
            ),
            if (isLoading &&
                (state.state == LoadingState.progress ||
                    state.state == LoadingState.install))
              CircularProgressIndicator(value: state.value)
          ],
        ),
      );
    });
  }
}
