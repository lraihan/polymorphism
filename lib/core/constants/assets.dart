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

  // ── Works gallery ──────────────────────────────────────────────────────
  //
  // Curated real-product imagery: ROAST + FE Touch are real screenshots;
  // ELSSA / ProFund / SIGAP were rendered from their live prototypes. Each
  // list is ordered by visual impact — `first` is the hero shot.

  static const String _g = 'assets/works/_gallery';

  static const List<String> roast = [
    '$_g/roast/01-pos-menu.jpg',
    '$_g/roast/02-order-cart.jpg',
    '$_g/roast/03-orders.jpg',
    '$_g/roast/04-owner-dashboard.jpg',
    '$_g/roast/05-ops-dashboard.jpg',
    '$_g/roast/06-login.jpg',
  ];

  static const List<String> feTouch = [
    '$_g/fe-teller/01-dashboard.jpg',
    '$_g/fe-teller/02-transaction.jpg',
    '$_g/fe-teller/03-login.jpg',
  ];

  static const List<String> elssa = [
    '$_g/elssa/01-morning.jpg',
    '$_g/elssa/02-parent.jpg',
    '$_g/elssa/03-student.jpg',
    '$_g/elssa/04-teacher.jpg',
    '$_g/elssa/05-homeroom.jpg',
    '$_g/elssa/06-principal.jpg',
  ];

  static const List<String> profund = [
    '$_g/profund/01-login.jpg',
    '$_g/profund/02-dashboard.jpg',
    '$_g/profund/03-exception.jpg',
    '$_g/profund/04-cashflow.jpg',
    '$_g/profund/05-projects.jpg',
    '$_g/profund/06-approval.jpg',
    '$_g/profund/07-reports.jpg',
  ];

  static const List<String> sigap = [
    '$_g/sigap/01-idle.jpg',
    '$_g/sigap/02-alert.jpg',
    '$_g/sigap/03-dispatch.jpg',
    '$_g/sigap/04-resolved.jpg',
  ];

  static const List<String> balai = [
    '$_g/balai/01-home.jpg',
    '$_g/balai/02-seller.jpg',
    '$_g/balai/03-curator.jpg',
    '$_g/balai/04-drops.jpg',
  ];

  static const List<String> fitx = [
    '$_g/fitx/01-home.jpg',
    '$_g/fitx/02-progress.jpg',
    '$_g/fitx/03-booking.jpg',
    '$_g/fitx/04-profile.jpg',
    '$_g/fitx/05-trainer.jpg',
  ];

  /// Assets the intro decodes before the curtain lifts — logo, the B&W
  /// fragments (About is reached early), and each project's hero shot. The
  /// hero foreground fades in on mount; the heavy hero background loads lazily.
  static List<String> get preload => [
    logo,
    ...fragments,
    roast.first,
    feTouch.first,
    elssa.first,
    profund.first,
    fitx.first,
    sigap.first,
  ];
}
