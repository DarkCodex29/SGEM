import 'package:flutter/material.dart';

class FyHover extends StatefulWidget {
  final Widget Function(bool isHover) builder;
  const FyHover({super.key, required this.builder});

  @override
  State<FyHover> createState() => _FyHoverState();
}

class _FyHoverState extends State<FyHover> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => _mouserEnter(true),
      onExit: (e) => _mouserEnter(false),
      child: widget.builder(isHover),
    );
  }

  void _mouserEnter(bool isHovering) {
    setState(() {
      isHover = isHovering;
    });
  }
}
