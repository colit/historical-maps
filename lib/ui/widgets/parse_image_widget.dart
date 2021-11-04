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
            return Image.memory((snapshot.data as ParseWebFile).file!);
          } else {
            return Image.file((snapshot.data as ParseFile).file!);
          }
        } else {
          return Container();
        }
      },
    );
  }
}
