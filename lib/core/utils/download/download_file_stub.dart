import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

/// Non-web fallback — opens the file URL (download attribute is web-only).
void downloadFile(String url, {String filename = ''}) {
  unawaited(launchUrl(Uri.parse(url)));
}
