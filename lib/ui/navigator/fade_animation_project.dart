import 'package:flutter/material.dart';

class FadeAnimationPage extends Page {
  const FadeAnimationPage({Key? key, this.child})
      : super(key: key as LocalKey?);
  final Widget? child;

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) {
        var curveTween = CurveTween(curve: Curves.easeIn);
        return FadeTransition(
          opacity: animation.drive(curveTween),
          child: child,
        );
      },
    );
  }
}
