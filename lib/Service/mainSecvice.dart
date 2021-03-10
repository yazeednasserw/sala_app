import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

enum ServerType {
  live, //one8 live server
  dev, //one8 development server
  local, //loacl is kinda of using the app with no server but with dummy data
}
Map<ServerType, String> on8Srvers = {
  ServerType.live: "https://one8-app.com",
  ServerType.dev: "http://18.157.81.42",
  ServerType.local: ""
};

//App server .. to change server only chage type
//Note: after changing server you have to change Firebase
//configration too for ios and android
ServerType appServerType = ServerType.dev;

class mainSecvice {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore firebaseFirestoreInstance = FirebaseFirestore.instance;
  static final StorageReference storageReference = FirebaseStorage().ref();
  ValueNotifier<User> firebaseUser = ValueNotifier<User>(null);

  //server
  final String mainApiURL = on8Srvers[appServerType] + "/api/v1";

  Future<http.Response> myPost({String url, Map<String, dynamic> data, String token}) async {
    var client = http.Client();

    try {
      Map<String, String> headers;
      headers['X-Requested-With'] = 'XMLHttpRequest';
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      http.Response res = await client.post(url, body: data, headers: headers);
      print(res.body);
//      print(await client.get(uriResponse.body));
    } catch (e) {} finally {
      client.close();
    }
  }

  Future<http.Response> myGet(String url, {String token}) async {
    var client = http.Client();

    try {
      Map<String, String> headers;
      headers['X-Requested-With'] = 'XMLHttpRequest';
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      http.Response res = await client.get(url, headers: headers);
      print(res.body);
      return res;
//      print(await client.get(uriResponse.body));
    } catch (e) {} finally {
      client.close();
    }
  }

  List<String> getListOfStringErrors(Response<dynamic> apiResponse) {
    List<String> list = [];
    if (apiResponse != null &&
        apiResponse.data != null &&
        apiResponse.data["errors"] != null &&
        apiResponse.data is Map<String, dynamic> &&
        apiResponse.data["errors"] is Map<String, dynamic>) {
      print("all is ok with getListOfStringErrors :)");
      Map<String, dynamic> bodyData = apiResponse.data["errors"] as Map<String, dynamic>;
      bodyData.forEach((key, value) {
        print(key.toString() + ":" + value.toString());
        (value as List<dynamic>).forEach((element) {
          print(element);
          if (element is String) {
            print("Found String error!");
            list.add(element);
          }
        });
      });
      return list;
    } else {
      print("Not ok with getListOfStringErrors!");

      return list; //empty
    }
  }

  // Future<void> signInAnonymously(dynamic callback) async {
  //   await _auth.signInAnonymously().then((authResult) async {
  //     firebaseUser.value = authResult.user;
  //     callback(authResult);
  //   }).catchError((Object object) async {
  //     print('Got an error:' + object.toString());
  //     callback(object);
  //   });
  // }
}
