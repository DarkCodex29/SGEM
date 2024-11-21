import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension GetSnackbar on GetInterface {
  void errorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white.withOpacity(0.6),
      colorText: Colors.red,
      icon: const Icon(
        Icons.error,
        color: Colors.red,
      ),
    );
  }
}

