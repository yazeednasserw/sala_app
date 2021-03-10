import 'dart:async';
import 'package:dio/dio.dart';

import 'mainSecvice.dart';

// ignore: camel_case_types
class TempService extends mainSecvice {
  List<String> error = [];

  @override
  Future<bool> getInfo({String token}) async {
    error = null;
    var dio = Dio();
    dio.options.headers['X-Requested-With'] = 'XMLHttpRequest';
    dio.options.headers['Authorization'] = 'Bearer $token';

    Response response;
    bool isSet;
    try {
      Map<String, dynamic> data = {
        'id': "0", //test only
      };

      response = await dio.post('$mainApiURL/apiTempService', data: data);

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
        error.add("Error : somthing wrong happend! ");
      }
    }
  }
}
