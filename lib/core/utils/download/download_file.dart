// Download a file in the browser (web build) or fall back to opening its URL.
export 'download_file_stub.dart' if (dart.library.html) 'download_file_web.dart';
