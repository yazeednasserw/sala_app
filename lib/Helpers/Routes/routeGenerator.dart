import 'dart:io';

import 'package:flutter/material.dart';

import 'package:sala_app/Service/initialService.dart';
import 'package:sala_app/Service/tempService.dart';
import 'package:sala_app/View/Temp/tempView.dart';
import 'package:sala_app/ViewModel/initialViewModel.dart';
import 'package:sala_app/View/Initial/initialView.dart';
import 'package:sala_app/ViewModel/mainVM.dart';
import 'package:sala_app/ViewModel/tempViewModel.dart';

class routeGenerator {
//  static final mainVM MainVM = mainVM;
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //getting arguments
    final args = settings.arguments;
    final mainVMVar = MainVM();
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => InitialView(initialVM: InitialViewModel(initialService: InitialService(), mainVM: mainVMVar)),
        );

      case 'Temp':
        return MaterialPageRoute(
          builder: (_) => TempView(tempVM: TempViewModel(tempService: TempService(), mainVM: mainVMVar)),
        );

      default:
        return _errorRoute();
    }
  } //end generateRoute

  static Route<dynamic> _errorRoute() {
    RouteSettings s = RouteSettings(name: '/'); //home route

    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text("Error!! Route"),
        ),
      );
    });
  }

//Navigator
//  static void popAllAndToReStart(BuildContext context) {
//    popAllAndPushNamedReplacement(context, "/");
//  }
//
//  static void popAllAndPushNamedReplacement(
//      BuildContext context, String routeName) {
//    Navigator.of(context)
//        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
//  }
//
//  static void pushReplacement(
//      BuildContext context,
//      String routeName, {
//        Object arguments,
//      }) {
//    Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
//  }
//
//  static void pushNamed(
//      BuildContext context,
//      String routeName, {
//        Object arguments,
//      }) {
//    Navigator.of(context).pushNamed(routeName, arguments: arguments);
//  }
//
//  static void popIfCanPop(BuildContext context) {
//    if (Navigator.canPop(context)) {
//      Navigator.pop(context);
//    }
//  }
//
//  static void popUntil(BuildContext context,String popUntilRouteName,) {
//    Navigator.popUntil(context,ModalRoute.withName(
//      popUntilRouteName,
//    ));
//  }
//
//  static void pushNamedAndRemoveUntil(
//      BuildContext context,
//      String pushRouteName,
//      String popUntilRouteName, {
//        Object arguments,
//      }) {
//    Navigator.of(context).pushNamedAndRemoveUntil(
//        pushRouteName,
//        ModalRoute,
//        arguments: arguments);
//
//  }
}
