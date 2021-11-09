import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

enum ImageDownloadState { idle, downloading, done, error, noImage }

class ParseImageWidget extends StatelessWidget {
  const ParseImageWidget({
    Key? key,
    required this.file,
    this.onReady,
    this.fit = BoxFit.cover,
  }) : super(key: key);
  final ParseFile file;
  final BoxFit fit;
  final Function? onReady;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ParseFileBase>(
      future: file.download(),
      builder: (BuildContext context, AsyncSnapshot<ParseFileBase> snapshot) {
        if (snapshot.hasData) {
          onReady?.call();
          if (kIsWeb) {
            return _FadeInImage(
                image: Image.memory((snapshot.data as ParseWebFile).file!));
          } else {
            return _FadeInImage(
              image: Image.file((snapshot.data as ParseFile).file!,
                  fit: BoxFit.cover),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class _FadeInImage extends StatefulWidget {
  const _FadeInImage({Key? key, required this.image}) : super(key: key);

  final Image image;

  @override
  __FadeInImageState createState() => __FadeInImageState();
}

class __FadeInImageState extends State<_FadeInImage>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  )..animateTo(1); //..repeat(reverse: false);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.image,
    );
  }
}
