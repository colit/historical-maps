import 'package:flutter/material.dart';
import '../navigator/destination.dart';

import 'enums.dart';

List<Destination> kDestinations = <Destination>[
  Destination(
    index: 0,
    icon: const Icon(
      Icons.map,
      size: 38,
    ),
    pageType: PageType.map,
  ),
  Destination(
    index: 1,
    icon: const Icon(
      Icons.info,
      size: 38,
    ),
    pageType: PageType.notes,
  ),
];
