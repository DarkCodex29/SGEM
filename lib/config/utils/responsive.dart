import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  late double _width;
  late double _height;

  Responsive(this.context) {
    final size = MediaQuery.of(context).size;
    _width = size.width;
    _height = size.height;
  }

  double widthPercent(double percent) {
    return _width * percent / 100;
  }

  double heightPercent(double percent) {
    return _height * percent / 100;
  }

  double fontSize(double fontSize) {
    return fontSize * (_width / 375);
  }

  EdgeInsets marginHorizontal(double percent) {
    return EdgeInsets.symmetric(horizontal: widthPercent(percent));
  }

  EdgeInsets marginVertical(double percent) {
    return EdgeInsets.symmetric(vertical: heightPercent(percent));
  }

  EdgeInsets paddingAll(double percent) {
    return EdgeInsets.all(widthPercent(percent));
  }

  bool isMobile() => _width < 600;
  bool isTablet() => _width >= 600 && _width <= 900;
  bool isDesktop() => _width > 900;
}
