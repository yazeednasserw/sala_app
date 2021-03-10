import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:sala_app/Helpers/Di/get_it.dart';

@lazySingleton
class Responsive {
  static Size _device;
  static bool _allowFontAccesibility, _useSafeArea;
  static MediaQueryData _mediaQueryData;

  static get instance => getIt.get<Responsive>();

  init({
    @required MediaQueryData mediaQueryData,
    double width = 100,
    double height = 100,
    bool allowFontAccesibility = true,
    bool useSafeArea = false,
  }) {
    _mediaQueryData = mediaQueryData;
    _device = Size(width, height);
    _allowFontAccesibility = allowFontAccesibility;
    _useSafeArea = useSafeArea;
  }

  double wdp(double pixels) {
    final padding = _useSafeArea ? _mediaQueryData.padding.left + _mediaQueryData.padding.right : 0;
    final deviceWidth = _mediaQueryData.size.width; //  * _mediaQueryData.devicePixelRatio;
    final ratio = (deviceWidth - padding) / _device.width;
    return pixels * ratio;
  }

  double hdp(double pixels) {
    final padding = _useSafeArea ? _mediaQueryData.padding.top + _mediaQueryData.padding.bottom : 0;
    final deviceHeight = _mediaQueryData.size.height; //  * _mediaQueryData.devicePixelRatio;
    final ratio = (deviceHeight - padding) / _device.height;
    return pixels * ratio;
  }

  double sp(double pixels) {
    // debugPrint(_mediaQueryData.toString());
    final value = min(wdp(pixels), hdp(pixels));
    return _allowFontAccesibility ? value : value / _mediaQueryData.textScaleFactor;
  }

  double wf(double percent) {
    return (wdp(_device.width) / 100) * percent;
  }

  double hf(double percent) {
    return (hdp(_device.height) / 100) * percent;
  }
}

extension MediaQueryResponsive on MediaQueryData {
  void responsive({
    double width = 100,
    double height = 100,
    bool allowFontAccesibility = true,
    bool useSafeArea = false,
  }) {
    Responsive.instance.init(
        mediaQueryData: this,
        width: width,
        height: height,
        allowFontAccesibility: allowFontAccesibility,
        useSafeArea: useSafeArea);
  }
}

extension ResponsiveMeasurements on num {
  num get wdp => Responsive.instance.wdp(this.toDouble());
  num get hdp => Responsive.instance.hdp(this.toDouble());
  num get sp => Responsive.instance.sp(this.toDouble());
  num get wf => Responsive.instance.wf(this.toDouble());
  num get hf => Responsive.instance.hf(this.toDouble());
}
