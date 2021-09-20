import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:historical_maps/core/entitles/shell_state.dart';
import 'package:historical_maps/ui/view_models/bottom_navigation_model.dart';

import '../../core/services/shell_state_service.dart';
import '../../ui/navigator/shell_router_delegate.dart';

class AppShell extends StatefulWidget {
  const AppShell({Key? key}) : super(key: key);

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late ShellRouterDelegate _routerDelegate;
  ChildBackButtonDispatcher? _backButtonDispatcher;

  @override
  void initState() {
    print('AppShell.initState');
    super.initState();
    _routerDelegate = ShellRouterDelegate();
    // init shell
    // WidgetsBinding.instance!.addPostFrameCallback((_) => _initShell());
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('AppShell.didUpdateWidget');
  }

  @override
  void didChangeDependencies() {
    print('AppShell.didChangeDependencies');
    super.didChangeDependencies();
    _backButtonDispatcher = Router.of(context)
        .backButtonDispatcher!
        .createChildBackButtonDispatcher();
  }

  @override
  Widget build(BuildContext context) {
    print('AppShell.build');
    var model = BottomNavigationModel(
      shellStateService: Provider.of<ShellStateService>(context, listen: false),
      labels: [
        'Stadtkarten',
        'Informationen',
      ],
    );
    _backButtonDispatcher!.takePriority();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Router(
        routerDelegate: _routerDelegate,
        backButtonDispatcher: _backButtonDispatcher,
      ),
      bottomNavigationBar: Consumer<ShellState>(
        builder: (context, value, child) => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: model.navigationItems,
          currentIndex: value.currentShellIndex!,
          onTap: (index) => model.onItemTapped(index),
        ),
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    print('AppShell was deactivated');
    //Router.of(context).backButtonDispatcher.forget(_backButtonDispatcher);
  }

  @override
  void dispose() {
    super.dispose();
    print('AppShell was disposed');
  }
}
