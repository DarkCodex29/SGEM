import 'package:flutter/material.dart';
import 'package:sgem/config/theme/app_theme.dart';

class ActiveDropdownField extends StatelessWidget {
  const ActiveDropdownField(
      {super.key, this.value, this.onChanged, this.readOnly = false});

  final bool? value;
  final bool readOnly;
  final void Function(bool?)? onChanged;

  static const options = [
    (true, 'Activo'),
    (false, 'Inactivo'),
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<bool>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Estado',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppTheme.alternateColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppTheme.alternateColor,
            width: 2,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      onChanged: readOnly ? null : onChanged,
      items: options
          .map(
            (option) => DropdownMenuItem(
              value: option.$1,
              child: Text(option.$2),
            ),
          )
          .toList(),
    );
  }
}
