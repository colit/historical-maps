import 'package:flutter/material.dart';
import 'package:historical_maps/ui/commons/map_icons.dart';
import '../navigator/destination.dart';

import 'enums.dart';

List<Destination> kDestinations = <Destination>[
  Destination(
    index: 0,
    icon: const Icon(
      MapIcons.map,
      size: 38,
    ),
    pageType: PageType.map,
  ),
  Destination(
    index: 1,
    icon: const Icon(
      MapIcons.info,
      size: 38,
    ),
    pageType: PageType.notes,
  ),
];
