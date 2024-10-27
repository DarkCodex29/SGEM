import 'package:flutter/material.dart';
import 'package:sgem/config/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final Widget? icon;
  final bool isRequired;
  final Function()? onIconPressed;
  final bool isReadOnly;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final bool? enabled;
  const CustomTextField(
      {super.key,
      required this.label,
      required this.controller,
      this.isPassword = false,
      this.keyboardType = TextInputType.text,
      this.icon,
      this.isRequired = false,
      this.onIconPressed,
      this.isReadOnly = false,
      this.onChanged,
      this.focusNode,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              keyboardType: keyboardType,
              readOnly: isReadOnly,
              onChanged: onChanged,
              focusNode: focusNode,
              enabled: enabled,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(
                  color: AppTheme.primaryText,
                ),
                suffixIcon: icon != null
                    ? IconButton(
                        icon: icon!,
                        onPressed: onIconPressed,
                      )
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppTheme.alternateColor,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppTheme.backgroundBlue,
                    width: 1.0,
                  ),
                ),
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
            ),
        ],
      ),
    );
  }
}
