import 'package:flutter/widgets.dart';

/// Every asset path used by the app. No string literals at call sites.
class AppAssets {
  AppAssets._();

  static const String logo = 'assets/images/logo.png';
  static const String avatar = 'assets/images/avatar.png';

  /// Hero portrait layers. [heroForeground] is the composed, low-poly face on
  /// black (the default); [heroBackground] is the colourful, smiling self
  /// surrounded by real work, revealed under the cursor mask.
  static const String heroForeground = 'assets/images/Foreground.jpg';
  static const String heroBackground = 'assets/images/Background--.jpg';

  /// The six B&W "ink-drip" portrait fragments used in the About collage.
  static List<String> get fragments => [for (var n = 1; n <= 6; n++) 'assets/images/fragment$n.png'];

  /// Both hero photos are 3840×2160. Decode them once at a capped width so the
  /// pair doesn't blow the 100 MB image cache, and share the *same* provider
  /// between preload and render so the cache key matches (no double decode).
  static ImageProvider heroProvider(String path) => ResizeImage(AssetImage(path), width: 2048);

  /// Screenshot paths for a work entry: `works/project<n>-<1..3>.png`.
  static List<String> projectImages(int n) =>
      List.generate(3, (i) => 'assets/images/works/project$n-${i + 1}.png');

  /// First (card) screenshot for a work entry.
  static String projectCover(int n) => 'assets/images/works/project$n-1.png';

  /// Assets the intro decodes before the curtain lifts — what the first two
  /// screens need: the logo, each project's card image, and the small B&W
  /// fragments (the About section is reached early). The hero foreground fades
  /// in on mount and the 4 MB hero background loads lazily once the hero is
  /// visible; the two detail screenshots per project load when `/work/:id`
  /// opens.
  static List<String> get preload => [
    logo,
    for (var n = 1; n <= 6; n++) projectCover(n),
    ...fragments,
  ];
}
