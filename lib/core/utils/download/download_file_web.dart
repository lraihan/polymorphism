// Flutter-web file download via a transient <a download> element. Selected by
// the conditional export in download_file.dart; only compiled on web.
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

/// Triggers a browser download of [url], suggesting [filename] (same-origin).
void downloadFile(String url, {String filename = ''}) {
  final anchor = html.AnchorElement(href: url)
    ..download = filename
    ..style.display = 'none';
  html.document.body?.append(anchor);
  anchor
    ..click()
    ..remove();
}
