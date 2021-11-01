import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

enum ImageDownloadState { idle, downloading, done, error, noImage }

class ParseImageWidget extends StatelessWidget {
  const ParseImageWidget({
    Key? key,
    required this.file,
    this.fit = BoxFit.cover,
  }) : super(key: key);
  final ParseFile file;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ParseFileBase>(
      future: file.download(),
      builder: (BuildContext context, AsyncSnapshot<ParseFileBase> snapshot) {
        if (snapshot.hasData) {
          if (kIsWeb) {
            return Image.memory((snapshot.data as ParseWebFile).file!);
          } else {
            return Image.file((snapshot.data as ParseFile).file!);
          }
        } else {
          return AspectRatio(
            aspectRatio: 1.4,
            child: Container(
              color: const Color(0xffbbbbbb),
              child: const Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
