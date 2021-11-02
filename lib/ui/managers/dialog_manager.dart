import 'package:flutter/material.dart';
import 'package:historical_maps/ui/commons/colors.dart';
import '../../core/entitles/alert_message.dart';
import '../../core/services/bottom_sheet_service.dart';
import '../../core/services/dialog_service.dart';

class DialogManager extends StatefulWidget {
  const DialogManager(
      {Key? key,
      this.child,
      required DialogService dialogService,
      required BottomSheetService bottomSheetService})
      : _dialogService = dialogService,
        _bottomSheetService = bottomSheetService,
        super(key: key);

  final Widget? child;
  final DialogService _dialogService;
  final BottomSheetService _bottomSheetService;

  @override
  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  late DialogService widgetDialogService;
  late BottomSheetService bottomSheetService;
  @override
  void initState() {
    super.initState();
    widgetDialogService = widget._dialogService;
    widgetDialogService
        .registerDialogListener((message) => _showDialog(message));
    bottomSheetService = widget._bottomSheetService;
    bottomSheetService
        .registerBottomSheetListener((child) => _showModalSheet(child));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }

  void _showModalSheet(Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (context) => Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: kColorBackgroundMiddle,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              child,
            ],
          ),
        ],
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
    );
  }

  void _showDialog(AlertMessage message) async {
    var actions = <Widget>[];
    if (message.actions == null) {
      actions.add(TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Ok', style: Theme.of(context).textTheme.button),
      ));
    } else {
      for (var a in message.actions!) {
        actions.add(TextButton(
          onPressed: () {
            if (a.action != null) {
              a.action!();
            }
            Navigator.of(context).pop();
          },
          child: Text(a.label!, style: Theme.of(context).textTheme.button),
        ));
      }
    }
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        scrollable: true,
        title: Text(
          message.title!,
          style: Theme.of(context).textTheme.headline1,
        ),
        content: Text(
          message.content!,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        actions: actions,
      ),
    ).then((val) {
      widgetDialogService.dialogComplete();
    });
  }
}
