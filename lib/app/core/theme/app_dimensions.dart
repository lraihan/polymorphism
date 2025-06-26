import 'package:flutter/material.dart';

class AppSizes {
  // Padding
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Margin
  static const double marginXS = 4.0;
  static const double marginS = 8.0;
  static const double marginM = 16.0;
  static const double marginL = 24.0;
  static const double marginXL = 32.0;
  static const double marginXXL = 48.0;

  // Border Radius
  static const double radiusXS = 12.0;
  static const double radiusS = 16.0;
  static const double radiusM = 20.0;
  static const double radiusL = 24.0;
  static const double radiusXL = 28.0;
  static const double radiusCircle = 50.0;

  // Icon Sizes
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  static const double iconXXL = 64.0;

  // Button Heights
  static const double buttonHeightS = 32.0;
  static const double buttonHeightM = 44.0;
  static const double buttonHeightL = 56.0;
  static const double buttonHeightXL = 64.0;

  // Input Heights
  static const double inputHeightS = 40.0;
  static const double inputHeightM = 48.0;
  static const double inputHeightL = 56.0;

  // App Bar
  static const double appBarHeight = 56.0;
  static const double appBarHeightLarge = 72.0;

  // Bottom Navigation
  static const double bottomNavHeight = 60.0;

  // Card
  static const double cardElevation = 4.0;
  static const double cardElevationHover = 8.0;

  // Avatar
  static const double avatarS = 32.0;
  static const double avatarM = 48.0;
  static const double avatarL = 64.0;
  static const double avatarXL = 96.0;

  // Divider
  static const double dividerThickness = 1.0;
  static const double dividerIndent = 16.0;

  // Breakpoints
  static const double breakpointMobile = 480.0;
  static const double breakpointTablet = 768.0;
  static const double breakpointDesktop = 1024.0;
  static const double breakpointWide = 1440.0;
}

class AppSpacing {
  static const EdgeInsets zero = EdgeInsets.zero;

  // All sides
  static const EdgeInsets xs = EdgeInsets.all(AppSizes.paddingXS);
  static const EdgeInsets s = EdgeInsets.all(AppSizes.paddingS);
  static const EdgeInsets m = EdgeInsets.all(AppSizes.paddingM);
  static const EdgeInsets l = EdgeInsets.all(AppSizes.paddingL);
  static const EdgeInsets xl = EdgeInsets.all(AppSizes.paddingXL);
  static const EdgeInsets xxl = EdgeInsets.all(AppSizes.paddingXXL);

  // Horizontal
  static const EdgeInsets horizontalXS = EdgeInsets.symmetric(horizontal: AppSizes.paddingXS);
  static const EdgeInsets horizontalS = EdgeInsets.symmetric(horizontal: AppSizes.paddingS);
  static const EdgeInsets horizontalM = EdgeInsets.symmetric(horizontal: AppSizes.paddingM);
  static const EdgeInsets horizontalL = EdgeInsets.symmetric(horizontal: AppSizes.paddingL);
  static const EdgeInsets horizontalXL = EdgeInsets.symmetric(horizontal: AppSizes.paddingXL);

  // Vertical
  static const EdgeInsets verticalXS = EdgeInsets.symmetric(vertical: AppSizes.paddingXS);
  static const EdgeInsets verticalS = EdgeInsets.symmetric(vertical: AppSizes.paddingS);
  static const EdgeInsets verticalM = EdgeInsets.symmetric(vertical: AppSizes.paddingM);
  static const EdgeInsets verticalL = EdgeInsets.symmetric(vertical: AppSizes.paddingL);
  static const EdgeInsets verticalXL = EdgeInsets.symmetric(vertical: AppSizes.paddingXL);

  // Individual sides
  static const EdgeInsets topXS = EdgeInsets.only(top: AppSizes.paddingXS);
  static const EdgeInsets topS = EdgeInsets.only(top: AppSizes.paddingS);
  static const EdgeInsets topM = EdgeInsets.only(top: AppSizes.paddingM);
  static const EdgeInsets topL = EdgeInsets.only(top: AppSizes.paddingL);
  static const EdgeInsets topXL = EdgeInsets.only(top: AppSizes.paddingXL);

  static const EdgeInsets bottomXS = EdgeInsets.only(bottom: AppSizes.paddingXS);
  static const EdgeInsets bottomS = EdgeInsets.only(bottom: AppSizes.paddingS);
  static const EdgeInsets bottomM = EdgeInsets.only(bottom: AppSizes.paddingM);
  static const EdgeInsets bottomL = EdgeInsets.only(bottom: AppSizes.paddingL);
  static const EdgeInsets bottomXL = EdgeInsets.only(bottom: AppSizes.paddingXL);

  static const EdgeInsets leftXS = EdgeInsets.only(left: AppSizes.paddingXS);
  static const EdgeInsets leftS = EdgeInsets.only(left: AppSizes.paddingS);
  static const EdgeInsets leftM = EdgeInsets.only(left: AppSizes.paddingM);
  static const EdgeInsets leftL = EdgeInsets.only(left: AppSizes.paddingL);
  static const EdgeInsets leftXL = EdgeInsets.only(left: AppSizes.paddingXL);

  static const EdgeInsets rightXS = EdgeInsets.only(right: AppSizes.paddingXS);
  static const EdgeInsets rightS = EdgeInsets.only(right: AppSizes.paddingS);
  static const EdgeInsets rightM = EdgeInsets.only(right: AppSizes.paddingM);
  static const EdgeInsets rightL = EdgeInsets.only(right: AppSizes.paddingL);
  static const EdgeInsets rightXL = EdgeInsets.only(right: AppSizes.paddingXL);
}

class AppBorderRadius {
  static const BorderRadius zero = BorderRadius.zero;

  static const BorderRadius xs = BorderRadius.all(Radius.circular(AppSizes.radiusXS));
  static const BorderRadius s = BorderRadius.all(Radius.circular(AppSizes.radiusS));
  static const BorderRadius m = BorderRadius.all(Radius.circular(AppSizes.radiusM));
  static const BorderRadius l = BorderRadius.all(Radius.circular(AppSizes.radiusL));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(AppSizes.radiusXL));
  static const BorderRadius circle = BorderRadius.all(Radius.circular(AppSizes.radiusCircle));

  static const BorderRadius topXS = BorderRadius.only(
    topLeft: Radius.circular(AppSizes.radiusXS),
    topRight: Radius.circular(AppSizes.radiusXS),
  );
  static const BorderRadius topS = BorderRadius.only(
    topLeft: Radius.circular(AppSizes.radiusS),
    topRight: Radius.circular(AppSizes.radiusS),
  );
  static const BorderRadius topM = BorderRadius.only(
    topLeft: Radius.circular(AppSizes.radiusM),
    topRight: Radius.circular(AppSizes.radiusM),
  );
  static const BorderRadius topL = BorderRadius.only(
    topLeft: Radius.circular(AppSizes.radiusL),
    topRight: Radius.circular(AppSizes.radiusL),
  );
  static const BorderRadius topXL = BorderRadius.only(
    topLeft: Radius.circular(AppSizes.radiusXL),
    topRight: Radius.circular(AppSizes.radiusXL),
  );

  static const BorderRadius bottomXS = BorderRadius.only(
    bottomLeft: Radius.circular(AppSizes.radiusXS),
    bottomRight: Radius.circular(AppSizes.radiusXS),
  );
  static const BorderRadius bottomS = BorderRadius.only(
    bottomLeft: Radius.circular(AppSizes.radiusS),
    bottomRight: Radius.circular(AppSizes.radiusS),
  );
  static const BorderRadius bottomM = BorderRadius.only(
    bottomLeft: Radius.circular(AppSizes.radiusM),
    bottomRight: Radius.circular(AppSizes.radiusM),
  );
  static const BorderRadius bottomL = BorderRadius.only(
    bottomLeft: Radius.circular(AppSizes.radiusL),
    bottomRight: Radius.circular(AppSizes.radiusL),
  );
  static const BorderRadius bottomXL = BorderRadius.only(
    bottomLeft: Radius.circular(AppSizes.radiusXL),
    bottomRight: Radius.circular(AppSizes.radiusXL),
  );
}
