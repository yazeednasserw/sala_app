// import 'dart:async';
// import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:device_info/device_info.dart';
// import 'package:sala_app/Helpers/Routes/Nav.dart';
// =import 'package:sala_app/ViewModel/mainVM.dart';

// class NotificationHandler {
//   final mainVM MainVM;
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final FirebaseMessaging _fcm = FirebaseMessaging();
//   NotificationHandler({this.MainVM}) {
//     try {
//       print("setting NotificationHandler...");
//       setFBNotificatioInfo();
//     } catch (e) {
//       print("Yazeed: Excetion While setting NotificationHandler!...");
//       print(e);
//     }
//   }

//   StreamSubscription iosSubscription;

//   void saveFCMUserInfo() async {
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     String fcmTokenId = await _fcm.getToken();
//     fcmTokenId = fcmTokenId != null ? fcmTokenId : "null";
//     String os = Platform.operatingSystem;
//     String osVersion;

//     if (Platform.isIOS) {
//       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//       osVersion = iosInfo.systemVersion;
//       if (os == null) {
//         os = "ios";
//       }
//     } else if (Platform.isAndroid) {
//       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//       osVersion = androidInfo.version.release;
//       if (os == null) {
//         os = "android";
//       }
//     }

//     print(fcmTokenId);
//     print(os);
//     print(osVersion);
//     //set notification info to global obj
//     MainVM.setNotificationInfo(os, osVersion, fcmTokenId);
//   }

//   setFBNotificatioInfo() {
//     //check if info already set, and set info if not
//     if (!MainVM.isNotificationInfoSet()) {
//       if (Platform.isIOS) {
//         print('os is ios');
//         iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
//           // save the token  OR subscribe to a topic here
//           saveFCMUserInfo();
//         });

//         _fcm.requestNotificationPermissions(IosNotificationSettings(sound: true, alert: true, badge: true));
//       } else if (Platform.isAndroid) {
//         print('os is android');
//         saveFCMUserInfo();
//       }
//     } //end set
//     setFBNnotificationConfigure();
//     //showDummyNotification();
//   }

//   setFBNnotificationConfigure() {
//     _fcm.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//         String messageTile = message['notification']['title'] as String;
//         String massageComment = message['notification']['body'] as String;
//         MainVM.showNotification("$massageComment", "$messageTile", messageMap: message);
//         // MainVM.showNotification("$massageComment", "$messageTile", onTap: () {
//         //   directToOrder(message);
//         // });
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//         String messageTile = message['notification']['title'] as String;
//         String massageComment = message['notification']['body'] as String;
//         MainVM.showNotification("$massageComment", "$messageTile", messageMap: message);
//         // MainVM.showNotification("$massageComment", "$messageTile", onTap: () {
//         //   directToOrder(message);
//         // }); // TODO optional
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//         String messageTile = message['notification']['title'] as String;
//         String massageComment = message['notification']['body'] as String;
//         MainVM.showNotification("$massageComment", "$messageTile", messageMap: message);
//         // MainVM.showNotification("$massageComment", "$messageTile", onTap: () {
//         //   directToOrder(message);
//         // }); // TODO optional
//       },
//     );
//   }

//   Function directToOrder(Map<String, dynamic> message) {
//     Function directionFunction = () {};
//     try {
//       if (message["order_id"] != null) {
//         int orderId = message["order_id"] as int;
//         if (orderId != null) {
//           // if (message["order"] is Map && message["order.id"] is int) {
//           print("found order ...");
//           Order order = Order(orderID: orderId);
//           directionFunction = () {
//             myNavigator.pushNamed(mainVM.getCurrentViewContext(), "manageOredr", arguments: {"order": order});
//           };
//         }
//       }
//     } catch (e) {
//       print(e);
//     }
//     return directionFunction;
//   }
// }
