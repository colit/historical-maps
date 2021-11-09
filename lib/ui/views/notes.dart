import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:historical_maps/ui/commons/about_txt.dart';
import 'package:historical_maps/ui/commons/ui_helpers.dart';

class NotesView extends StatelessWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceMedium),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/graphics/logo.png'),
                  UIHelper.verticalSpaceMedium(),
                  const MarkdownBody(
                    data: kAboutMarkDown,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
