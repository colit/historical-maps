import 'package:geolocator/geolocator.dart';
import 'package:historical_maps/core/data_source/database_repository.dart';
import 'package:historical_maps/core/entitles/loading_state_value.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:historical_maps/core/services/maps_service.dart';

import 'core/data_source/persistent_repository.dart';
import 'core/entitles/app_page.dart';
import 'core/entitles/shell_state.dart';
import 'core/entitles/startup_state.dart';
import 'core/services/bottom_sheet_service.dart';
import 'core/services/dialog_service.dart';
import 'core/services/gallery_service.dart';
import 'core/services/location_service.dart';
import 'core/services/shell_state_service.dart';
import 'core/services/startup_service.dart';
import 'ui/commons/enums.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders,
];

List<SingleChildWidget> independentServices = [
  Provider(create: (_) => PersistentRepository()),
  Provider(create: (_) => MongoDatabaseRepository()),
  Provider(create: (_) => StartupService()),
  Provider(create: (_) => LocationService()),
  Provider(create: (_) => ShellStateService()),
  Provider(create: (_) => BottomSheetService()),
  Provider(create: (_) => DialogService()),
  Provider(create: (_) => GalleryService()),
];

List<SingleChildWidget> dependentServices = [
  ProxyProvider2<MongoDatabaseRepository, PersistentRepository, MapService>(
    update: (_, databaseRepository, persistentRepository, __) => MapService(
      databaseRepository: databaseRepository,
      persistentRepository: persistentRepository,
    ),
  ),
  // ProxyProvider<DialogService, GeolocatorService>(
  //   update: (_, dialogService, __) =>
  //       GeolocatorService(dialogService: dialogService),
  // ),
];

List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<StartupState>(
    initialData: StartupState(PageType.startup),
    create: (context) =>
        Provider.of<StartupService>(context, listen: false).startupState,
  ),
  StreamProvider<ShellState>(
    initialData:
        ShellState(pages: [AppPage(type: PageType.map)], currentShellIndex: 0),
    create: (context) =>
        Provider.of<ShellStateService>(context, listen: false).shellState,
  ),
  StreamProvider<LoadingValue>(
    initialData: LoadingValue(),
    create: (context) =>
        Provider.of<MapService>(context, listen: false).loadingState,
  ),
  StreamProvider<Position?>(
    initialData: null,
    create: (context) =>
        Provider.of<LocationService>(context, listen: false).positionStream,
  )
];
