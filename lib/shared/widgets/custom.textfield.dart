import 'package:flutter/material.dart';
import 'package:sgem/config/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.icon,
    this.isRequired = false,
    this.onIconPressed,
    this.isReadOnly = false,
    this.onChanged,
    this.maxLines = 1,
    this.validator,
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

  final String? Function(String?)? validator;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, child) {
                return TextFormField(
                  controller: controller,
                  obscureText: isPassword,
                  keyboardType: keyboardType,
                  readOnly: isReadOnly,
                  onChanged: onChanged,
                  maxLines: maxLines,
                  validator: (v) {
                    if (isRequired && v!.isEmpty) {
                      return 'Campo obligatorio';
                    }
                    return validator?.call(v);
                  },
                  decoration: InputDecoration(
                    // hintText: value.text.isEmpty ? label : null,
                    // labelText: value.text.isNotEmpty ? label : null,
                    labelText: label,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: value.text.isNotEmpty
                          ? AppTheme.primaryColor
                          : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    suffixIcon: icon != null
                        ? IconButton(
                            icon: IconTheme(
                              data: IconThemeData(
                                color: value.text.isNotEmpty
                                    ? AppTheme.primaryColor
                                    : Colors.grey,
                              ),
                              child: icon!,
                            ),
                            onPressed: onIconPressed,
                          )
                        : null,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.alternateColor,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryColor,
                        width: 2.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                  ),
                );
              },
            ),
          ),
          if (isRequired)
            const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
