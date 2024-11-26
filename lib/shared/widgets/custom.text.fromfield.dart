import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sgem/config/theme/app_theme.dart';

class CustomTextFormField extends StatelessWidget {
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
  final TextInputType inputType;
  final bool? enabled;
  final bool isMultiEmail;
  final TextStyle textStyle;
  final int maxLength;
  final int? maxLines;
  const CustomTextFormField(
      {super.key,
      required this.label,
      required this.controller,
      this.isPassword = false,
      this.keyboardType = TextInputType.text,
      this.icon,
      this.isRequired = true,
      this.onIconPressed,
      this.isReadOnly = false,
      this.onChanged,
      this.focusNode,
      this.inputType = TextInputType.text,
      this.isMultiEmail = false,
      this.enabled = true,
      this.maxLength = 250,
      this.maxLines,
      this.textStyle = const TextStyle()});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: isPassword,
              keyboardType: keyboardType,
              readOnly: isReadOnly,
              onChanged: onChanged,
              focusNode: focusNode,
              enabled: enabled,
              style: textStyle,
              maxLines: maxLines,
              inputFormatters: [
                LengthLimitingTextInputFormatter(maxLength), // Limita a 2 caracteres
              ],
              validator: (value) {
                if (!isRequired) {
                  return null;
                }

                if (value != null && value.trim().isEmpty) {
                  return 'Campo requerido';
                }
                if (inputType == TextInputType.emailAddress) {
                  if (isMultiEmail) {
                    final res = value!.split(";");
                    bool isError = false;
                    for (final item in res) {
                      if (!isEmailValid(item)) {
                        isError = true;
                        break;
                      }
                    }
                    if (isError) {
                      return 'Ingrese un email valido';
                    }
                    return null;
                  }
                  if (!isEmailValid(value!)) {
                    return 'Ingrese un email valido';
                  }
                }
                return null;
              },
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
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 1.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.red,
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

bool isEmailValid(String email) {
  final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return regex.hasMatch(email);
}
