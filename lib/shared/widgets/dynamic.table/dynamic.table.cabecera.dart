import 'package:flutter/material.dart';

class DynamicTableCabecera extends StatelessWidget {
  final List<String> cabecera;

  const DynamicTableCabecera({super.key, required this.cabecera});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: Row(
        children: cabecera.map((header) {
          return Expanded(
            flex: 1,
            child: Text(
              header,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ),
    );
  }
}
