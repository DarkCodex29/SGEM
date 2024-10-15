
import 'package:flutter/material.dart';

class DropdownField extends StatefulWidget {
  final List<String> options;
  final ValueChanged<String?> onValueChanged;

  const DropdownField({super.key, required this.options, required this.onValueChanged});

  @override
  _DropdownFieldState createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Select an option',
        border: OutlineInputBorder(),
      ),
      value: _selectedItem,
      items: widget.options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedItem = newValue;
        });
        // Comunica el valor seleccionado al widget padre
        widget.onValueChanged(newValue);
      },
      validator: (value) {
        if (value == null) {
          return 'Please select an option';
        }
        return null;
      },
    );
  }
}