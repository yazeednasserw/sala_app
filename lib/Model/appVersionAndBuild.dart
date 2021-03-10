import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class AppVersionAndBuild {
  int version; //int ver
  final String stringVersion;
  final int build;

  AppVersionAndBuild({@required this.stringVersion, @required this.build}) {
    this.version = perseVerionToInt(stringVersion);
  }

//will set string ver to int
//like 1.0.6 > 106
  static int perseVerionToInt(String version) {
    try {
      int ver = int.parse(version.replaceAll('.', ''));
      return ver;
    } catch (e) {
      return 0;
    }
  }

  //check if current app-ver is minmum than given app-ver;
  // 105(40) , 167(19) true
  // 105(40) , 105(19) false
  // 105(40) , 167(40) true
  // 105(40) , 105(40) false

  bool checkVerIsMinmumThan(AppVersionAndBuild appVer) {
    print("current : " + toString());
    print("given appVer : " + appVer.toString());

    if (appVer == null) return false;

    if (version < appVer.version) {
      return true;
    } else if (version == appVer.version && build < appVer.build) {
      return true;
    } else {
      return false;
    }
  }

  @override
  String toString() => "AppVersionAndBuild<$stringVersion:$version:$build>";
}
