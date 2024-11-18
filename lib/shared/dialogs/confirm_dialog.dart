import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/shared/widgets/app_button.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    this.title = '¿Está seguro de guardar los datos?',
    super.key,
  });

  final String title;

  Future<bool?> show() async => Get.dialog<bool>(this);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: SizedBox(
        width: 350,
        height: 220,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/guardar.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back<bool>(result: false),
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Calibri',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton.white(
                      text: 'No',
                      onPressed: () => Get.back<bool>(result: false),
                    ),
                    const SizedBox(width: 12),
                    AppButton.green(
                      text: 'Si',
                      onPressed: () => Get.back<bool>(result: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
