import 'package:flutter/material.dart';

import 'colors.dart';

/// Contains useful functions to reduce boilerplate code
class UIHelper {
  // Vertical spacing constants. Adjust to your liking.
  static const double kVerticalSpaceSmall = 10.0;
  static const double kVerticalSpaceMedium = 20.0;
  static const double kVerticalSpaceLarge = 60.0;

  // Vertical spacing constants. Adjust to your liking.
  static const double kHorizontalSpaceSmall = 10.0;
  static const double kHorizontalSpaceMedium = 15.0;
  static const double kHorizontalSpaceLarge = 30.0;

  /// Returns a vertical space with height set to [kVerticalSpaceSmall]
  static Widget verticalSpaceSmall() {
    return verticalSpace(kVerticalSpaceSmall);
  }

  /// Returns a vertical space with height set to [kVerticalSpaceMedium]
  static Widget verticalSpaceMedium() {
    return verticalSpace(kVerticalSpaceMedium);
  }

  /// Returns a vertical space with height set to [kVerticalSpaceLarge]
  static Widget verticalSpaceLarge() {
    return verticalSpace(kVerticalSpaceLarge);
  }

  /// Returns a vertical space equal to the [height] supplied
  static Widget verticalSpace(double height) {
    return SizedBox(height: height);
  }

  /// Returns a vertical space with height set to [kHorizontalSpaceSmall]
  static Widget horizontalSpaceSmall() {
    return horizontalSpace(kHorizontalSpaceSmall);
  }

  /// Returns a vertical space with height set to [kHorizontalSpaceMedium]
  static Widget horizontalSpaceMedium() {
    return horizontalSpace(kHorizontalSpaceMedium);
  }

  /// Returns a vertical space with height set to [kHorizontalSpaceLarge]
  static Widget horizontalSpaceLarge() {
    return horizontalSpace(kHorizontalSpaceLarge);
  }

  /// Returns a vertical space equal to the [width] supplied
  static Widget horizontalSpace(double width) {
    return SizedBox(width: width);
  }
}
