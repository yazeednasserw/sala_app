import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sala_app/Helpers/Routes/nav.dart';
import 'package:sala_app/Model/appVersionAndBuild.dart';
import 'package:sala_app/Service/initialService.dart';
import 'package:sala_app/Service/mainSecvice.dart';
import 'package:sala_app/ViewModel/mainVM.dart';
import 'package:package_info/package_info.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';

class InitialViewModel extends Model {
  ///variables
  //API helpers
  final InitialService initialService;
  final MainVM mainVM;
  BuildContext ViewCotext;

  //verstion
  AppVersionAndBuild currentAppVer;
  AppVersionAndBuild remoteAppMinmumVer;

  //View variables
  bool isLoding = true;
  List<String> viewErrors = [];

  //View actions
  double loadingAnimatedContainerHeight = 0;

  initSetup(BuildContext context) {
    ViewCotext = context;
    checkVerion();
    //the initial context shall cleacr the list that holds context in the mainVM
    mainVM.resetContextList();
    //go and set context
    updateMainContext(context);
  }

  checkVerion() async {
    String currentVer;
    int currentBuild;
    try {
      remoteAppMinmumVer = await initialService.getRemoteMinimumAppVersion();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      currentVer = packageInfo.version;
      currentBuild = int.tryParse(packageInfo.buildNumber);
      if (currentVer != null && currentBuild != null) {
        currentAppVer = AppVersionAndBuild(stringVersion: currentVer, build: currentBuild);
        if (currentAppVer.checkVerIsMinmumThan(remoteAppMinmumVer) == true) {
          MainVM.showVerUpdateDiloag();
        }
      }
    } catch (e) {}
  }

//to update main context for mainVM .. use at top of build ..to be called allwase
  updateMainContext(BuildContext context) {
    mainVM.setCurrentViewContext(ViewCotext);
  }

  checkMemoryInfo() async {
    showLoadingAnimatedContainerHeight();
    await mainVM.setUserTokenFromMemoryIfLggedIn();
    print("isLoggedIn:${mainVM.isLoggedIn == true}");
    if (mainVM.isLoggedIn == true) {
      Nav.popAllAndPushNamedReplacement(ViewCotext, "Temp");
    } else {
      Nav.popAllAndPushNamedReplacement(ViewCotext, "Temp");
    }
  }

  showLoadingAnimatedContainerHeight() {
    loadingAnimatedContainerHeight = 100;
    notifyListeners();
  }

  startLoading() {
    print("loading starts ...");
    isLoding = true;
    notifyListeners();
  }

  endLoading() {
    print("loading ended!");
    isLoding = false;
    notifyListeners();
  }

  clearErrors() {
    viewErrors = [];
    notifyListeners();
  }

  onGettingBtnPressed() async {
    await getInfo(onSuccess: onSuccessGetInfo);
  }

  onSuccessGetInfo() {
    print("Success getting info");
  }

  Future getInfo({Function onSuccess}) async {
    print("getting Info ...");
    bool isOrderPLaced;
    startLoading();
    try {
      isOrderPLaced = await initialService.getInfo(token: mainVM.getUserToken());
      if (isOrderPLaced != null && initialService.error == null) {
        mainVM.showSuccess("Info got");
      } else {
        viewErrors.add(initialService.error.toString());
      }
    } catch (e) {
      viewErrors.add(initialService.error.toString());
    }
    endLoading();
    notifyListeners();
  }

  ///Constructor
  InitialViewModel({@required this.initialService, @required this.mainVM});

  ///initial results

  Future<bool> getUserInfo() async {
    return false;
  }

//Api-link

}
