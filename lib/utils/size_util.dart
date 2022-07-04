import 'package:flutter/material.dart';

class SizeUtil {
  static late MediaQueryData _mediaQueryData;
  static late double _textScaleFactor;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    _textScaleFactor = MediaQuery.textScaleFactorOf(context);
  }

  static double percentWidth(double num) {
    return num / 100 * _mediaQueryData.size.width;
  }

  static double percentHeight(double num) {
    return num / 100 * (_mediaQueryData.size.height - statusBarHeight());
  }

  static double statusBarHeight() {
    return _mediaQueryData.padding.top;
  }

  static double setSp(double num) {
    return num / _textScaleFactor;
  }
}

extension SizeExtension on num {
  double get w => SizeUtil.percentWidth(this.toDouble());
  double get h => SizeUtil.percentHeight(this.toDouble());
  double get sp => SizeUtil.setSp(this.toDouble());
}
