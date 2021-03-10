//this class will include all info needed to be accessed from all VMs
//NOTE: must be created in (the main.dart/or where you create your VMs) and passed it along with all MVs
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:sala_app/Helpers/LanguageLocalization/app_localizations.dart';
import 'package:sala_app/Helpers/Routes/nav.dart';
// import 'package:sala_app/Helpers/notificationHandler.dart';
// import 'package:sala_app/Models/user.dart';
import 'package:sala_app/View/Widgets/myDialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _GUserToken;
// User _GUser;
List<BuildContext> _listOfContexts = [];
BuildContext _CurrentViewContext() => _listOfContexts.last;
//device
String OS;
String OSVersion;
String FCMTokenId;

class MainVM extends Model {
  //Singleton
  static final MainVM _mainVM = MainVM._internal();
  factory MainVM() {
    return _mainVM;
  }
  MainVM._internal() {
    try {
      print("setting NotificationHandler...");
      // notificationHandler = NotificationHandler(MainVM: this);
    } catch (e) {
      print("Yazeed: Excetion While setting NotificationHandler!...");
      print(e);
    }
  }

  //Golale ids
  static final String gogleMapsKey = "AIzaSyCl4Y0sPXxSSj-DZ2PJa20-5fmOLaDn7HI";
  //note : the next key is the same publishable token but encoded into base64
  static final String moyasaraPymentApiKey = "cGtfdGVzdF9TWG43VDMyUkU2VGJObkFtRURWQUJtd3lINUFURFhZMTVVN0JXcGV6Og==";

  bool isUserTokenSetFromMemoryIfLggedIn = false;
  bool isNotFirstUse; //to check if this is the Firs use of the app or not

  Function performHotRestart;

//to hold pending action when view hasnt been set yet
  List<Function> actinsAfteSettingContext = [];
  addPendingAction(Function actionToBeDone) {
    if (actionToBeDone != null) {
      actinsAfteSettingContext.add(actionToBeDone);
    }
  }

  callPendingActions() {
    try {
      for (Function f in actinsAfteSettingContext) {
        f();
      }
    } catch (e) {
      print(e);
    }
    actinsAfteSettingContext = [];
  }

  //vars
  int userId;
//  String userToken;
  bool isLoggedIn;
  // flushbar
  bool showing = false;

  //nontification info
  // NotificationHandler notificationHandler;

  //view management
  // static BuildContext _currentViewContext;
  static BuildContext getCurrentViewContext() {
    return _CurrentViewContext();
  }

//to reset list of all contexts
  resetContextList() {
    print("context set ${_listOfContexts}");
    _listOfContexts = [];
    Locale('en', '');
  }

//to remove last context on back view action
  removeLastContextOnPopView(BuildContext context) {
    print("context poped ${_listOfContexts.last}");
    if (_listOfContexts.last == context) {
      _listOfContexts.removeLast();
      callPendingActions();
      Locale('en', '');
    }
  }

  setCurrentViewContext(BuildContext context) {
    if (_listOfContexts != null && _listOfContexts.isEmpty != true) {
      //check list
      if (context != _listOfContexts.last) {
        print("context set $context");
        //check doublcation
        _listOfContexts.add(context);
      } else {
        _listOfContexts.last = context;
      }
    } else {
      print("context set $context");

      _listOfContexts = [context];
    }
    callPendingActions();
    Locale('en', '');
  }

  //language
  static void setLangAndReloadApp(String language_code) {
    Locale newLocale;
  }

  //to save user info in memory after logging in
  // User currentLoggedInUser;
  int selectedNavigationBarItemIndex = 0;

  //permission handler
  List<Permission> permissions;

  setPermission() {
    permissions = Permission.values.where((Permission permission) {
      if (Platform.isIOS) {
        return (permission != Permission.unknown) &&
            (permission == Permission.locationWhenInUse ||
                permission == Permission.location ||
                permission == Permission.notification);
      } else {
        return (permission != Permission.unknown) &&
            (permission == Permission.location || permission == Permission.notification);
      }
    }).toList();
  }

  //use this in the ui!
  //Note: call in checking and also to request permissions
  Future<bool> preparePermissionsToBeGranted(BuildContext context) async {
    print("preparePermissionsToBeGranted..");

    if (permissions != null) {
      print("yes..");
      if (await _checkIsAllPermissionsGranted()) {
        //all per r set
        return true;
      } else {
        //some or all not set!
        await _requestPermissions();
      }
    } else {
      print("no..");

      setPermission();
      return preparePermissionsToBeGranted(context);
    }
  }

  Future<bool> _checkIsAllPermissionsGranted() async {
    print("checkIsAllPermissionsGranted..");

    for (Permission p in permissions) {
      print(p);
      if (!await p.status.isGranted) {
        return false;
      } else {}
    }
    return true;
  }

  Future<void> _requestPermissions() async {
    print("requestPermissions..");
    for (Permission p in permissions) {
      print(p);
      if (await p.status.isGranted) {
      } else {
        print("requestting ${p} ...");

        PermissionStatus s = await p.request();
        if (s == PermissionStatus.granted) {
          //all is ok!
        } else {
          //show dilog to allow prmition
          showDilogToGoToSittengsForAllowingLocationPermissions(); //AppLocalizations.of(getCurrentViewContext()).translate("allow_notifications_from_settings"),

          // showErrors([
          // ]);
        }
      }
    }
  }

  showDilogToGoToSittengsForAllowingLocationPermissions() async {
    BuildContext context = getCurrentViewContext();
    dynamic isConfirm = await showActionDialog(
      context,
      Text(
        AppLocalizations.of(context).translate('sorry'),
      ),
      Text(AppLocalizations.of(context).translate("allow_notifications_from_settings")),
      actionText: AppLocalizations.of(context).translate("go_to_settings"),
    );
    if (isConfirm == false) return;
    //go to sittings
    AppSettings.openLocationSettings().then((x) {
      Navigator.pop(context);
    });
  }

  List<FFNavigationBarItem> _ffNavItemsProvider = [
    FFNavigationBarItem(
      iconData: Icons.home,
      label: 'Home',
    ),
    FFNavigationBarItem(
      iconData: Icons.account_circle,
      label: 'Profile',
    ),
    FFNavigationBarItem(
      iconData: Icons.train,
      label: 'Incoming orders',
    ),
  ];

  List<FFNavigationBarItem> _ffNavItemsNormalUser = [
    FFNavigationBarItem(
      iconData: Icons.home,
      label: 'Home',
    ),
    FFNavigationBarItem(
      iconData: Icons.account_circle,
      label: 'Profile',
    ),
  ];

  List<FFNavigationBarItem> ffNavBarItems() {
    return _ffNavItemsNormalUser;
  }

  onNavTaped(int index) {
    selectedNavigationBarItemIndex = index;
    //TODO: goToTappedView
    //add code : Yazeed

    notifyListeners();
  }

  //memory
  //will set to true .. so it wont show again
  Future<bool> setIsNotFirsUseToMemory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotFirstUse', true);
    print('isNotFirstUse set to memmory!!!');
    isNotFirstUse = true;
    return true;
  }

  Future<bool> setupIsNotFirsUseFromMemory() async {
    if (isNotFirstUse == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isNotFirestUseVar = await prefs.get('isNotFirstUse');
      if (isNotFirestUseVar != null) {
        print('isNotFirstUse set app from  memmory!!! -> $isNotFirestUseVar');
        isNotFirstUse = isNotFirestUseVar;
        return true;
      } else {
        //hasn't set before so give it default value;
        isNotFirstUse = false;
        return false;
      }
    }
    return true;
  }

  //to save user info in memory after logging in
  Future<bool> setUserTokenFromMemoryIfLggedIn() async {
    // if (!isUserTokenSetFromMemoryIfLggedIn) {
    //   bool isloggedIn = await User.isLoggedin();
    //   String userToken = await User.getUserTokenFromMemoryIfLoggedIn();
    //   int userId = await User.getUserIDFromMemoryIfLoggedIn();

    //   if (isloggedIn != null && userToken != null && userId != null) {
    //     _GUserToken = userToken;
    //     this.isLoggedIn = isloggedIn;
    //     this.userId = userId;
    //     print("user is logged in, token is set! from memory");
    //     isUserTokenSetFromMemoryIfLggedIn = true;

    //     return true;
    //   } else {
    //     isLoggedIn = false;
    //     print("user isnt logged in, no token to get from memory!");
    //     return false;
    //   }
    // }
    // return true;
  }

  //to unset user info from memory when user logs out
  Future<bool> unsetUserTokenFromMemoryIfLoggedOut() async {
    // bool isloggedOut = await User.logoutUser();
    // bool isloggedIn = await User.isLoggedin();

    // if (isloggedOut != null && isloggedIn != null && !isloggedIn && isloggedOut) {
    //   // user has logged out
    //   _GUserToken = null;
    //   this.isLoggedIn = isloggedIn;
    //   this.userId = null;

    //   print("user is logged out, token is unset! from memory");
    //   isUserTokenSetFromMemoryIfLggedIn = false;
    //   return true;
    // } else {
    //   isLoggedIn = false;
    //   print("user is already loggedOut, no token to get from memory!");
    //   return false;
    // }
  }

  _onTokenAdded(String newToken) {
    _GUserToken = newToken;
    print("new user Token added!");
    //TODO: goToTappedView
    //add code : Yazeed
    notifyListeners();
  }

  String getUserToken() {
    return _GUserToken;
  }

  // _onUserAdded(User user) {
  //   _GUser = user;
  //   print("user info added");
  //   //TODO: goToTappedView
  //   //add code : Yazeed
  //   notifyListeners();
  // }

  // onUserAndTokenAdded(User user, String newToken) {
  //   _onUserAdded(user);
  //   _onTokenAdded(newToken);
  //   _saveUserInfoAfterUserAdded(user, newToken);
  // }

  // Future<bool> onUserAndTokenRemoved() async {
  //   await onUserAndTokenAdded(null, null);
  //   // _onUserAdded(null);
  //   // _onTokenAdded(null);
  //   this.isLoggedIn = null;
  //   this.userId = null;
  //   return await _removeUserInfoAfterUserAdded();
  // }

  // Future<bool> _removeUserInfoAfterUserAdded() async {
  //   return await User.logoutUser();
  // }

  // _saveUserInfoAfterUserAdded(User user, String newToken) async {
  //   await User.saveLoginUserInfo(user.userID, user.mobile, newToken);
  // }

  bool setNotificationInfo(String os, String osVersion, String fcmTokenId) {
    print("---------os $os");
    print("---------osVersion $osVersion");
    print("---------fcmTokenId $fcmTokenId");

    if (os != null && osVersion != null && fcmTokenId != null) {
      OS = os;
      OSVersion = osVersion;
      FCMTokenId = fcmTokenId;
      print("Notification Info has set to global obj");
      return true;
    } else {
      print("Notification Info has NOT set!!! to global obj");
      return false;
    }
  }

  get os => OS;
  get osVersion => OSVersion;
  get fcmTokenId => FCMTokenId;

  bool isNotificationInfoSet() {
    if (OS != null && OSVersion != null && FCMTokenId != null) {
      //info is set
      return true;
    } else {
      return false;
    }
  }

  // User getUser() {
  //   return _GUser;
  // }

  // bool isUserNormalUser() {
  //   User user = getUser();
  //   return user?.userType == UserType.normalUser ? true : false;
  // }

  // bool isUserProvider() {
  //   User user = getUser();
  //   return user?.userType == UserType.provider ? true : false;
  // }

  // bool isUserAdmin() {
  //   User user = getUser();
  //   return user?.userType == UserType.admin ? true : false;
  // }

  // bool isUserNotLoggedIn() {
  //   User user = getUser();
  //   return user?.userType == UserType.non ? true : false;
  // }

  showNoInternetError() {
    showErrors([AppLocalizations.of(_CurrentViewContext()).translate("check_your_internet")]);
  }

  showErrors(List<String> errors) {
    print("mainVM Errors: $errors");
    if (errors != null && errors.length != 0 && _CurrentViewContext != null) {
      String error = "";
      errors.forEach((element) => {
            if (element != "" && element != null)
              {error = "${error}${AppLocalizations.of(_CurrentViewContext()).translate(element).toString()}\n"}
          });
      if (error != "" && error != null && !showing) {
        print("->${error.toString()} ${error.runtimeType}");
        Flushbar flushBar = Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: Colors.redAccent,
          flushbarStyle: FlushbarStyle.GROUNDED,
          isDismissible: true,
          message: error,
          duration: Duration(seconds: 2),
        );
        flushBar
          ..onStatusChanged = (FlushbarStatus status) {
            switch (status) {
              case FlushbarStatus.SHOWING:
                {
                  //doSomething();
                  break;
                }
              case FlushbarStatus.IS_APPEARING:
                {
                  showing = true;
                  notifyListeners();
                  // doSomethingElse();
                  break;
                }
              case FlushbarStatus.IS_HIDING:
                {
                  //doSomethingElse();
                  break;
                }
              case FlushbarStatus.DISMISSED:
                {
                  showing = false;
                  notifyListeners();
                  // doSomethingElse();
                  break;
                }
            }
          }
          ..show(_CurrentViewContext());
      }
    }
  }

  showSuccess(String msg) {
    try {
      if (msg != null && msg != "" && _CurrentViewContext != null) {
        Flushbar(
          flushbarPosition: FlushbarPosition.BOTTOM,
          backgroundColor: Colors.green,
          flushbarStyle: FlushbarStyle.GROUNDED,
          isDismissible: true,
          message: AppLocalizations.of(_CurrentViewContext()).translate(msg).toString(),
          duration: Duration(seconds: 5),
        )..show(_CurrentViewContext());
      }
    } catch (e) {
      print(e);
    }
  }

  showNotification(String msg, String title, {Map<String, dynamic> messageMap}) {
    print("show Notification :{msg>$msg,title>$title}");
    if (msg == null || msg == "null") {
      msg = getMessageFromMap(messageMap);
      print(msg);
    }
    if (title == null || title == "null") {
      title = getTitelFromMap(messageMap);
      print(title);
    }
    if (title != null && title != "" && msg != null && msg != "" && msg != "null" && _CurrentViewContext != null) {
      print("notification params checkd (sucsess) :) \nshowing notification ....");
      Function onTap;
      try {
        // onTap = directToOrder(messageMap);
        Flushbar(
          title: title != null ? title : null,
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: Colors.grey,
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          isDismissible: true,
          message: msg != null ? msg : null,
          duration: Duration(seconds: 5),
          onTap: (x) => onTap,
        )..show(_CurrentViewContext());
      } catch (e) {
        addPendingAction(onTap);
        print(e);
      }
    } else {
      print("notification params checkd (fail) :( \ncant show notification ....");
    }
  }

  // directToOrder(Map<String, dynamic> message) {
  //   if (Platform.isIOS) {
  //     try {
  //       String type = message["type"] as String;
  //       print(type);
  //       int oredrId;

  //       if (type != null) {
  //         switch (type) {
  //           case "new_offer":
  //             return {oredrId = int.parse(message["order_id"]), _pushToManageOredr(Order(orderID: oredrId))};
  //           case "order_status_changed":
  //             return {oredrId = int.parse(message["id"]), _pushToManageOredr(Order(orderID: oredrId))};
  //           case "offer_status_changed":
  //             return {oredrId = int.parse(message["order_id"]), _pushToManageOredr(Order(orderID: oredrId))};
  //           case "new_order":
  //             return {oredrId = int.parse(message["id"]), _pushToManageOredr(Order(orderID: oredrId))};
  //           default:
  //             return type.toString();
  //         }
  //       }
  //     } catch (e) {
  //       print(e);
  //     }
  //   } else {
  //     try {
  //       String type = message["data"]["type"] as String;
  //       int oredrId;

  //       if (type != null) {
  //         switch (type) {
  //           case "new_offer":
  //             return {oredrId = int.parse(message["data"]["order_id"]), _pushToManageOredr(Order(orderID: oredrId))};
  //           case "order_status_changed":
  //             return {oredrId = int.parse(message["data"]["id"]), _pushToManageOredr(Order(orderID: oredrId))};
  //           case "offer_status_changed":
  //             return {oredrId = int.parse(message["data"]["order_id"]), _pushToManageOredr(Order(orderID: oredrId))};
  //           case "new_order":
  //             return {oredrId = int.parse(message["data"]["id"]), _pushToManageOredr(Order(orderID: oredrId))};
  //           default:
  //             return type.toString();
  //         }
  //       }
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  // }

  static showVerUpdateDiloag() async {
    await Alert(
      context: _CurrentViewContext(),
      type: AlertType.none,
      title: 'نسختك غير مدعومة ، حمل النسخة الجديدة من متجر التطبيقات',
      style: AlertStyle(descStyle: TextStyle(fontSize: 14), titleStyle: TextStyle(fontSize: 18)),
      buttons: [
        DialogButton(
          child: Text(
            'حسنًا',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () {
            //exit(0);
          },
          width: 120,
        )
      ],
    ).show();
    //exit(0);
  }

  // _pushToManageOredr(Order order) {
  //   try {
  //     print("route: " + ModalRoute.of(_CurrentViewContext()).settings.name);
  //     if (ModalRoute.of(_CurrentViewContext()).settings.name != "manageOredr" &&
  //         ModalRoute.of(_CurrentViewContext()).settings.name != "plaseOrder") {
  //       Nav.pushNamed(_CurrentViewContext(), "manageOredr", arguments: {"order": order});
  //     }
  //   } catch (e) {}
  // }

  String getMessageFromMap(Map<String, dynamic> messageMap) {
    if (Platform.isIOS) {
      try {
        String msg = messageMap["message"] as String;
        String type = messageMap["type"] as String;
        if (msg != null) {
          return msg;
        } else if (type != null) {
          switch (type) {
            case "new_offer":
              return "new offer has been set";
            case "order_status_changed":
              return "order status has been changed";
            default:
              return type.toString();
          }
        }
      } catch (e) {
        print(e);
      }
    } else {
      try {
        String msg = messageMap["data"]["message"] as String;
        String type = messageMap["data"]["type"] as String;
        if (msg != null) {
          return msg;
        } else if (type != null) {
          switch (type) {
            case "new_offer":
              return "new offer has been set";
            case "order_status_changed":
              return "order status has been changed";
            default:
              return type.toString();
          }
        }
      } catch (e) {
        print(e);
      }
    }

    return null;
  }

  String getTitelFromMap(Map<String, dynamic> messageMap) {
    if (Platform.isIOS) {
      try {
        String msg = messageMap["title"] as String;
        String type = messageMap["type"] as String;
        if (msg != null) {
          return msg;
        } else if (type != null) {
          switch (type) {
            case "new_offer":
              return "new offer";
            case "order_status_changed":
              return "order status";
            default:
              return type.toString();
          }
        }
      } catch (e) {
        print(e);
      }
    } else {
      try {
        String msg = messageMap["data"]["title"] as String;
        String type = messageMap["data"]["type"] as String;
        if (msg != null) {
          return msg;
        } else if (type != null) {
          switch (type) {
            case "new_offer":
              return "new offer";
            case "order_status_changed":
              return "order status";
            default:
              return type.toString();
          }
        }
      } catch (e) {
        print(e);
      }
    }

    return null;
  }
}
