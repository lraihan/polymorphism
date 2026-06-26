// Embeds a live HTML prototype. On Flutter web this is a real <iframe>
// (prototype_view_web.dart); elsewhere it's a graceful placeholder
// (prototype_view_stub.dart).
// ignore: conditional_uri_does_not_exist
export 'prototype_view_stub.dart' if (dart.library.html) 'prototype_view_web.dart';
