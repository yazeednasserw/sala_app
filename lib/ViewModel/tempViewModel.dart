import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sala_app/Service/tempService.dart';
import 'package:sala_app/ViewModel/mainVM.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sala_app/Helpers/Routes/nav.dart';

class TempViewModel extends Model {
  ///variables
  //API helpers
  final TempService tempService;
  final MainVM mainVM;
  BuildContext ViewCotext;

  //View variables
  bool isLoding = true;
  List<String> viewErrors = [];

  //View actions
  initSetup(BuildContext context) {
    ViewCotext = context;
    updateMainContext(context);
  }

//to update main context for mainVM .. use at top of build ..to be called allwase
  updateMainContext(BuildContext context) {
    mainVM.setCurrentViewContext(ViewCotext);
  }

  backButtonTapped() {
    mainVM.removeLastContextOnPopView(ViewCotext);
    Nav.pop(ViewCotext);
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
//    myNavigator.popAllAndPushNamedReplacement(ViewCotext, "home");
  }

  Future getInfo({Function onSuccess}) async {
    print("getting Info ...");
    bool isOrderPLaced;
    startLoading();
    try {
      isOrderPLaced = await tempService.getInfo(token: mainVM.getUserToken());
      if (isOrderPLaced != null && tempService.error == null) {
        mainVM.showSuccess("Info got");
      } else {
        viewErrors.add(tempService.error.toString());
      }
    } catch (e) {
      viewErrors.add(tempService.error.toString());
    }
    endLoading();
    notifyListeners();
  }

  ///Constructor
  TempViewModel({@required this.tempService, @required this.mainVM});

  ///temp results

  Future<bool> getUserInfo() async {
    return false;
  }

//Api-link

}
