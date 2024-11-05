import 'package:flutter/material.dart';
import 'package:sgem/shared/utils/widgets/hover.dart';

class MonitoringCardWidget extends StatelessWidget {
  const MonitoringCardWidget({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return FyHover(
      builder: (bool isHover) {
        return Card(
          color: Colors.white,
          elevation: isHover ? 1.0 : 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: child,
          ),
        );
      },
    );
  }
}
