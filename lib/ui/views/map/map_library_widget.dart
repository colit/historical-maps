import 'package:flutter/material.dart';

class MapsLibraryWidget extends StatelessWidget {
  const MapsLibraryWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          height: 200,
          child: Container(
            color: Colors.amber.withAlpha(100),
          ),
        ),
      ),
    );
  }
}
