import 'package:flutter/material.dart';

// ignore: camel_case_types
class Nav {
  static void popAllAndToReStart(BuildContext context) {
    Nav.popAllAndPushNamedReplacement(context, "/");
  }

  static void popAllAndPushNamedReplacement(BuildContext context, String routeName, {Object arguments}) {
    Navigator.of(context).pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false, arguments: arguments);
  }

  static void pushReplacement(
    BuildContext context,
    String routeName, {
    Object arguments,
  }) {
    Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }

  static void pushNamed(
    BuildContext context,
    String routeName, {
    Object arguments,
  }) {
    //to avoid doublication route
    if (ModalRoute.of(context).settings.name != routeName) {
      Navigator.of(context).pushNamed(routeName, arguments: arguments);
    }
  }

  static void popIfCanPop(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  static void pop<T extends Object>(BuildContext context, {var v = null}) {
    Navigator.of(context).pop(v);
  }

  static void pushNamedAndRemoveUntil(
    BuildContext context,
    String pushRouteName,
    String popUntilRouteName, {
    Object arguments,
  }) {
    Navigator.of(context).pushNamedAndRemoveUntil(pushRouteName, ModalRoute.withName("/"), arguments: arguments);
  }
}
