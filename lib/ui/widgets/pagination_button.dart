import 'package:flutter/material.dart';
import 'package:historical_maps/ui/commons/colors.dart';

class PaginationButton extends StatelessWidget {
  const PaginationButton({
    Key? key,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  final Function? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: onTap == null ? 0 : 1,
      child: GestureDetector(
        onTap: () => onTap?.call(),
        child: Container(
          width: 50,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            color: Colors.white,
            border: Border.all(color: kColorDarkRed, width: 4),
          ),
          child: Icon(
            icon,
            color: kColorMainRed,
          ),
        ),
      ),
    );
  }
}
