import 'package:flutter/material.dart';

class ActiveBox extends StatelessWidget {
  const ActiveBox({
    required this.isActive,
    super.key,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Colors.green : Colors.red;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          isActive ? 'Activo' : 'Inactivo',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
