import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/modules/pages/capacitaciones/actualizacion.masiva/capacitacion.carga.masiva.controller.dart';

import '../../../../config/theme/app_theme.dart';

class CapacitacionCargaMasivaPage extends StatelessWidget {
  const CapacitacionCargaMasivaPage({super.key, required this.onCancel});
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final CapacitacionCargaMasivaController controller= Get.put(CapacitacionCargaMasivaController());
    return Scaffold(
      body: _buildCapacitacionCargaMasivaPage(
        controller,
        context,
      ),
    );
  }
  Widget _buildCapacitacionCargaMasivaPage(
      CapacitacionCargaMasivaController controller, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              //_buildSeccionFiltros(context, controller),
              const SizedBox(
                height: 20,
              ),
              //_buildSeccionResultado(controller),
              const SizedBox(
                height: 20,
              ),
              _buildRegresarButton(context)
            ],
          ),
        );
      },
    );
  }
  Widget _buildRegresarButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          //controller.resetControllers();
          onCancel();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        ),
        child: const Text("Regresar", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
