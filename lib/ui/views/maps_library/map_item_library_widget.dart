import 'package:flutter/material.dart';
import 'package:historical_maps/core/entitles/loading_state_value.dart';
import 'package:historical_maps/core/entitles/map_referece.dart';
import 'package:historical_maps/core/services/maps_service.dart';
import 'package:historical_maps/ui/commons/colors.dart';
import 'package:historical_maps/ui/commons/enums.dart';
import 'package:historical_maps/ui/commons/map_icons.dart';
import 'package:provider/provider.dart';

class MapLibraryItemWidget extends StatelessWidget {
  const MapLibraryItemWidget({
    Key? key,
    required this.mapItem,
    required int index,
    Function(int)? callback,
    this.isFirst = false,
    this.isLast = false,
  })  : _callback = callback,
        _index = index,
        super(key: key);

  final MapReference mapItem;
  final Function(int)? _callback;
  final int _index;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final isSelected =
        mapItem.id == Provider.of<MapService>(context).currentMap.id;
    return Consumer<LoadingValue>(builder: (context, state, child) {
      final isLoading =
          (state.objectId == mapItem.id && state.state != LoadingState.idle);
      return Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          if (!isFirst)
            Transform.translate(
              offset: const Offset(-33, 0),
              child: Container(
                color: Colors.black,
                width: 66,
                height: 80,
              ),
            ),
          if (!isLast)
            Transform.translate(
              offset: const Offset(33, 0),
              child: Container(
                color: Colors.black,
                width: 66,
                height: 80,
              ),
            ),
          if (isSelected)
            Container(
              alignment: Alignment.center,
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(46)),
                border: Border.all(
                  color: Colors.black,
                  width: 6,
                ),
              ),
            ),
          GestureDetector(
            onTap: () => _callback?.call(_index),
            child: Container(
              alignment: Alignment.center,
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isSelected ? kColorMainRed : Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(40)),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.black,
                  width: 6,
                ),
              ),
              child: Text(
                mapItem.year.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          if (!isFirst)
            Transform.translate(
              offset: const Offset(-65, 0),
              child: const Icon(
                MapIcons.more,
                color: Colors.white,
                size: 35,
              ),
            ),
          if (isLoading &&
              (state.state == LoadingState.progress ||
                  state.state == LoadingState.install))
            CircularProgressIndicator(value: state.value)
        ],
      );
    });
  }
}
