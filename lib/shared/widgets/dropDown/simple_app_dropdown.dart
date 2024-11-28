import 'package:flutter/material.dart';
import 'package:sgem/config/theme/app_theme.dart';

typedef _OptionValue = (int key, String nombre);

class SimpleAppDropdown extends StatelessWidget {
  const SimpleAppDropdown({
    required this.label,
    this.options,
    this.isRequired = false,
    this.readOnly = false,
    this.hint,
    this.disabledHint,
    this.initialValue,
    this.onChanged,
    super.key,
  });

  final List<_OptionValue>? options;
  final bool isRequired;
  final String? hint;
  final String label;
  final String? disabledHint;
  final bool readOnly;
  final void Function(int?)? onChanged;
  final int? initialValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _Dropdown(
              options: options!,
              value: initialValue,
              label: label,
              readOnly: readOnly,
              hint: hint,
              disabledHint: disabledHint,
              // onChanged: (_) {},
              onChanged: onChanged,
            ),
          ),
          if (isRequired)
            const Padding(
              padding: EdgeInsets.only(left: 6, bottom: 16),
              child: Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            )
          else
            const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({
    required this.options,
    required this.value,
    required this.label,
    this.readOnly = false,
    this.hint,
    this.disabledHint,
    this.onChanged,
  });

  final List<_OptionValue> options;
  final int? value;
  final void Function(int?)? onChanged;

  final String? hint;
  final String label;
  final String? disabledHint;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: value,
      isExpanded: true,
      hint: hint != null
          ? Text(
              hint!,
              style: const TextStyle(
                color: AppTheme.primaryText,
                fontSize: 16,
              ),
            )
          : null,
      decoration: InputDecoration(
        labelText: label,
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
      disabledHint: disabledHint != null
          ? Text(
              // initialValue?.nombre ?? hintText,
              disabledHint!,
              style: const TextStyle(color: Colors.grey),
            )
          : null,
    );
  }
}
