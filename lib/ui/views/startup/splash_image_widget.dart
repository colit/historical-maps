import 'package:flutter/material.dart';

class SplashImageWidget extends StatelessWidget {
  const SplashImageWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/graphics/splashscreen.jpg'),
            fit: BoxFit.cover),
      ),
    );
  }
}
