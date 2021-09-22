import 'package:flutter/material.dart';
import '../../../core/entitles/map_data.dart';

class MapLibraryItemWidget extends StatelessWidget {
  const MapLibraryItemWidget({
    Key? key,
    required this.mapItem,
    required int index,
    Function(int)? callback,
  })  : _callback = callback,
        _index = index,
        super(key: key);

  final MapData mapItem;
  final Function(int)? _callback;
  final int _index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _callback?.call(_index),
      child: Container(
        alignment: Alignment.center,
        child: Text(mapItem.year.toString()),
        color: Colors.amber.withAlpha(100),
      ),
    );
    // Container(
    //   alignment: Alignment.center,
    //   child: Text(mapItem.year.toString()),
    //   color: Colors.amber.withAlpha(100),
    // );
  }
}
