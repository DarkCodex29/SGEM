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
    this.hasTodos = false,
    super.key,
  });

  final List<_OptionValue>? options;
  final bool isRequired;
  final bool hasTodos;
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
              hasTodos: hasTodos,
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
    required this.hasTodos,
    this.readOnly = false,
    this.hint,
    this.disabledHint,
    this.onChanged,
  });

  final List<_OptionValue> options;
  final int? value;
  final void Function(int?)? onChanged;

  final bool hasTodos;

  final String? hint;
  final String label;
  final String? disabledHint;
  final bool readOnly;

  static final _todos = DropdownMenuItem(
    value: -1,
    child: const Text('Todos'),
  );

  @override
  Widget build(BuildContext context) {
    final newOptions = options
        .map(
          (option) => DropdownMenuItem(
            value: option.$1,
            child: Text(option.$2),
          ),
        )
        .toList();

    if (hasTodos) {
      newOptions.insert(0, _todos);
    }

    final newOnChanged = readOnly
        ? null
        : (hasTodos
            ? (int? value) => onChanged?.call(value == -1 ? null : value)
            : this.onChanged);

    return DropdownButtonFormField<int>(
      value: value ?? (hasTodos ? -1 : null),
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
      onChanged: readOnly ? null : newOnChanged,
      items: newOptions,
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
