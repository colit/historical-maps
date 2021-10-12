import 'package:flutter/material.dart';
import 'package:historical_maps/core/entitles/parse_image.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'core/commons/parse_const.dart';

class ParseInitApp extends StatelessWidget {
  const ParseInitApp({Key? key, required this.app}) : super(key: key);
  final Widget app;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Parse().initialize(
        ParseConstants.applicationId,
        ParseConstants.serverUrl,
        registeredSubClassMap: <String, ParseObjectConstructor>{
          'Image': () => ParseImage(),
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _ServerError();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return app;
        }
        return _Loading();
      },
    );
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('connecting Parse'),
        ),
      ),
    );
  }
}

class _ServerError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('Parse Error'),
        ),
      ),
    );
  }
}
