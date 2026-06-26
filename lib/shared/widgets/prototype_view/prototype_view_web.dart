// Flutter-web embed of a live HTML prototype via an <iframe> platform view.
// dart:html is the simplest way to construct the element; this file is only
// ever compiled on web (selected by the conditional export in
// prototype_view.dart).
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

/// Renders [url] (a same-origin path served from `web/`, e.g.
/// `prototypes/elssa.html`) inside an iframe that fills its box.
class PrototypeView extends StatelessWidget {
  const PrototypeView({required this.url, super.key});

  final String url;

  // registerViewFactory throws if the same id is registered twice.
  static final Set<String> _registered = <String>{};

  @override
  Widget build(BuildContext context) {
    final viewType = 'prototype:$url';
    if (_registered.add(viewType)) {
      ui_web.platformViewRegistry.registerViewFactory(
        viewType,
        (int viewId) => html.IFrameElement()
          ..src = url
          ..title = 'Interactive prototype'
          ..allowFullscreen = true
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%',
      );
    }
    return HtmlElementView(viewType: viewType);
  }
}
