import 'package:flutter/widgets.dart';

extension WidgetExtension on Widget {

  Widget padding(EdgeInsets insets) {
    return Container(
      padding: insets,
      child: this
    );
  }

  Widget size(double? height, double? width) {
    return Container(
      height: height,
      width: width,
      child: this
    );
  }
}