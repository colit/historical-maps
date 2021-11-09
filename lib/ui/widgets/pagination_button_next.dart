import 'package:flutter/material.dart';
import 'package:historical_maps/ui/commons/map_icons.dart';
import 'package:historical_maps/ui/commons/ui_helpers.dart';

enum PaginationButtonType {
  left,
  right,
}

class PaginationButtonNext extends StatelessWidget {
  const PaginationButtonNext({
    Key? key,
    required this.onTap,
    this.type = PaginationButtonType.left,
  }) : super(key: key);

  final Function onTap;
  final PaginationButtonType type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: UIHelper.kHorizontalSpaceSmall),
      child: GestureDetector(
        onTap: () => onTap.call(),
        child: Container(
          width: 48,
          height: 48,
          child: Icon(
            type == PaginationButtonType.left
                ? MapIcons.arrowBackward
                : MapIcons.arrowForward,
            color: Colors.white,
            size: 30,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.black38,
          ),
        ),
      ),
    );
  }
}
