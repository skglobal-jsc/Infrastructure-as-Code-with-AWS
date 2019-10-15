import 'dart:async';

import 'package:flutter/material.dart';

class Routing {
  static final Routing _instance = new Routing._internal();

  factory Routing() {
    return _instance;
  }

  Routing._internal();

  static Future<T> navigate2<T>(BuildContext context, WidgetBuilder builder, {bool replace = false, String routeName}) async {
    if (replace != null && replace) {
      await Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              settings: RouteSettings(name: routeName),
              builder: builder
              ));
      return null;
    }

    return Navigator.push<T>(context, new MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: builder
    ));
  }

  static void popToRoot(BuildContext context) {
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  static Future openDialog(BuildContext context, WidgetBuilder builder, {bool fullscreen}) async {
    return await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: builder,
        fullscreenDialog: fullscreen != null ? fullscreen : false,
      ));
  }
}
