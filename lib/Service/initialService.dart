import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:sala_app/Model/appVersionAndBuild.dart';

import 'mainSecvice.dart';

// ignore: camel_case_types

class InitialService extends mainSecvice {
  List<String> error = [];

  @override
  Future<bool> getInfo({String token}) async {
    error = [];
    var dio = Dio();
    dio.options.headers['X-Requested-With'] = 'XMLHttpRequest';
    dio.options.headers['Authorization'] = 'Bearer $token';

    Response response;
    bool isSet;
    try {
      Map<String, dynamic> data = {
        'id': "0", //test only
      };

      response = await dio.post('$mainApiURL/apiInitialService', data: data);

      print("response:");
      print(response.data);
      isSet = response.statusCode == 200 ? true : throw Exception;
      return isSet != null;
    } on DioError catch (e) {
      print("Error -- chateched");
      print(e.toString());
      print(e?.response.toString());
      print(e?.response?.statusCode.toString());

      if (e.response != null && e.response.statusCode == 400 || e.response.statusCode == 422) {
        //on error
        print("statusCode:");
        print(e.response.statusCode);
        print("response:");
        print(e.response);
        error = getListOfStringErrors(e.response);
      } else {
        error.add("some_thing_went_wrong");
      }
    }
  }

  Future<AppVersionAndBuild> getRemoteMinimumAppVersion() async {
    String version;
    int build;

    //get remot app version and build
    await mainSecvice.firebaseFirestoreInstance
        .collection("controller")
        .doc("minimumVersionToAccess")
        .get()
        .then((DocumentSnapshot doc) {
      Map map = doc.data();
      version = map['version'] != null ? map['version'] as String : "0";
      build = map['build'] != null ? map['build'] as int : 0;
    }).catchError((e) {
      print(e.toString());
      version = "0";
      build = 0;
    });

    //set and check current app
    return AppVersionAndBuild(stringVersion: version, build: build);
  }
}
