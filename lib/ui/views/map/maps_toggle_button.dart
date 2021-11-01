import 'package:flutter/material.dart';
import 'package:historical_maps/ui/commons/colors.dart';

class MapsToggleButton extends StatefulWidget {
  const MapsToggleButton({
    Key? key,
    required this.label,
    this.initWithHistoricalMap = true,
    Function(bool)? callback,
  })  : _callback = callback,
        super(key: key);

  final Function(bool)? _callback;
  final String label;
  final bool initWithHistoricalMap;

  @override
  State<MapsToggleButton> createState() => _MapsToggleButtonState();
}

class _MapsToggleButtonState extends State<MapsToggleButton>
    with SingleTickerProviderStateMixin {
  final double width = 70;
  final double height = 40;

  late final widgetSize = Size(width + height, height);

  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: Offset(-width / (2 * width + height), 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  ));

  @override
  Widget build(BuildContext context) {
    final isHistoricalMapVisible = widget.initWithHistoricalMap;
    _controller.animateTo(
      isHistoricalMapVisible ? 0 : 1,
      curve: isHistoricalMapVisible ? Curves.easeOut : Curves.easeIn,
    );
    return GestureDetector(
      onTap: () {
        widget._callback?.call(isHistoricalMapVisible);
      },
      child: SizedOverflowBox(
        alignment: Alignment.topLeft,
        size: widgetSize,
        child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          clipper: _CustomRect(widgetSize),
          child: SlideTransition(
            position: _offsetAnimation,
            child: Container(
              height: height,
              width: 2 * width + height,
              color: kColorMainRed,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        widget.label,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    height: height,
                    width: height,
                    decoration: BoxDecoration(
                      border: const Border.fromBorderSide(
                          BorderSide(width: 4, color: kColorMainRed)),
                      borderRadius: BorderRadius.circular(height / 2),
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: width,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Text(
                        'Heute',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _CustomRect extends CustomClipper<RRect> {
  _CustomRect(this.widgetSize);
  final Size widgetSize;
  @override
  RRect getClip(Size size) {
    RRect rect = RRect.fromRectAndRadius(
      Rect.fromLTRB(0, 0, widgetSize.width, widgetSize.height),
      Radius.circular(widgetSize.height / 2),
    );
    return rect;
  }

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) => false;
}
