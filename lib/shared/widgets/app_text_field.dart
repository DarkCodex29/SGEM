import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:sgem/config/theme/app_theme.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    required this.controller,
    super.key,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.icon,
    this.isRequired = false,
    this.onIconPressed,
    this.isReadOnly = false,
    this.onChanged,
    this.maxLines = 1,
    //this.focusNode,
  });

  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final Widget? icon;
  final bool isRequired;
  final Function()? onIconPressed;
  final bool isReadOnly;
  final Function(String)? onChanged;
  final int maxLines;

  static final _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
      color: AppTheme.alternateColor,
      width: 2,
    ),
  );

  @override
  Widget build(BuildContext context) {
    Logger('AppTextField').info('Building AppTextField $label');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              keyboardType: keyboardType,
              readOnly: isReadOnly,
              onChanged: onChanged,
              maxLines: maxLines,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(
                  color: AppTheme.primaryText,
                ),
                enabledBorder: _border,
                focusedBorder: _border,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
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
