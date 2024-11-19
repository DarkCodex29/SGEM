import 'package:flutter/material.dart';
import 'package:sgem/config/theme/app_theme.dart';

class AppButton extends StatelessWidget {
  const AppButton._({
    required this.backgroundColor,
    required this.textColor,
    required this.text,
    this.onPressed,
    this.borderColor,
    super.key,
  });

  const AppButton.green({
    required String text,
    VoidCallback? onPressed,
    Key? key,
  }) : this._(
          backgroundColor: AppTheme.successColor,
          textColor: Colors.white,
          text: text,
          onPressed: onPressed,
          key: key,
        );

  const AppButton.red({
    required String text,
    VoidCallback? onPressed,
    Key? key,
  }) : this._(
          backgroundColor: AppTheme.errorColor,
          textColor: Colors.white,
          text: text,
          onPressed: onPressed,
          key: key,
        );

  const AppButton.blue({
    required String text,
    VoidCallback? onPressed,
    Key? key,
  }) : this._(
          backgroundColor: AppTheme.primaryColor,
          textColor: Colors.white,
          text: text,
          onPressed: onPressed,
          key: key,
        );

  const AppButton.white({
    required String text,
    VoidCallback? onPressed,
    Key? key,
  }) : this._(
          backgroundColor: Colors.white,
          textColor: Colors.black,
          text: text,
          onPressed: onPressed,
          key: key,
          borderColor: AppTheme.alternateColor,
        );

  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 3,
        surfaceTintColor: backgroundColor,
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        textStyle: const TextStyle(
          fontSize: 16,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 20,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: borderColor != null
            ? BorderSide(color: borderColor!)
            : const BorderSide(color: Colors.transparent),
      ),
      child: Text(text),
    );
  }
}
