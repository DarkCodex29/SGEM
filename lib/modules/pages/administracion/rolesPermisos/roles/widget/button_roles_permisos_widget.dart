import 'package:flutter/material.dart';
import 'package:sgem/config/theme/app_theme.dart';


class ButtonRolesPermisos extends StatelessWidget {
  final String labelButton;
  final VoidCallback onTap;
  const ButtonRolesPermisos({
    required this.labelButton,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          padding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        ),
        child: Text(labelButton, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
