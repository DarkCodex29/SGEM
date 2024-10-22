import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/modules/pages/administracion/administracion.enum.dart';

import '../../../config/theme/app_theme.dart';
import 'administracion.controller.dart';
import 'maestro/maestro.page.dart';

class AdministracionPage extends StatelessWidget {
  const AdministracionPage({super.key});

  @override
  Widget build(BuildContext context) {
    AdministracionController controller = Get.put(AdministracionController());
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () {
            return Text(
              controller.screenPage.value.descripcion(),
              style: const TextStyle(
                color: AppTheme.backgroundBlue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        backgroundColor: AppTheme.primaryBackground,
      ),
      body: Obx(() {
        //Cambia la pantalla segun la seleccion 
        switch (controller.screenPage.value) {
          case AdministracionScreen.none:
            return _buildAdministracion(context, controller);
          case AdministracionScreen.maestro:
            return MaestroPage();
        }
      }),
    );
  }

  Widget _buildAdministracion(
      BuildContext context, AdministracionController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSeccionMantenimientos(context, controller),
              const SizedBox(
                height: 20,
              ),
              _buildSeccionSeguridad(context),
              const SizedBox(
                height: 20,
              ),
              //_buildRegresarButton(context)
            ],
          ),
        );
      },
    );
  }

  Widget _buildSeccionMantenimientos(
      BuildContext context, AdministracionController controller) {
    return ExpansionTile(
      initiallyExpanded: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white),
      ),
      title: const Text(
        "Mantenimientos generales",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              _buildSeccionMantenimientoPrimeraFila(controller),
              const SizedBox(
                height: 20,
              ),
              _buildSeccionMantenimientoSegundaFila(),
              // _buildBotonesAccion(controller)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionMantenimientoPrimeraFila(
      AdministracionController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildMantenimientoBotonMaestro(controller),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _buildMantenimientoBotonModulo(),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _buildMantenimientoBotonEmpresaCapacitadora(),
        ),
      ],
    );
  }

  Widget _buildMantenimientoBotonMaestro(AdministracionController controller) {
    return ElevatedButton.icon(
      onPressed: () async {
        controller.showMantenimientoMaestro();
        // controller.clearFields();
        // await controller.buscarActualizacionMasiva();
        // controller.isExpanded.value = false;
      },
      icon: const Icon(
        Icons.key,
        size: 18,
        color: Colors.white,
      ),
      label: const Text(
        "Maestro",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 49, vertical: 18),
        backgroundColor: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
      ),
    );
  }

  Widget _buildMantenimientoBotonModulo() {
    return ElevatedButton.icon(
      onPressed: () async {
        // controller.clearFields();
        // await controller.buscarActualizacionMasiva();
        // controller.isExpanded.value = false;
      },
      icon: const Icon(
        Icons.view_module_rounded,
        size: 18,
        color: Colors.white,
      ),
      label: const Text(
        "Modulo",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 49, vertical: 18),
        backgroundColor: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
      ),
    );
  }

  Widget _buildMantenimientoBotonEmpresaCapacitadora() {
    return ElevatedButton.icon(
      onPressed: () async {
        // controller.clearFields();
        // await controller.buscarActualizacionMasiva();
        // controller.isExpanded.value = false;
      },
      icon: const Icon(
        Icons.business_rounded,
        size: 18,
        color: Colors.white,
      ),
      label: const Text(
        "Empresa capacitadora",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 49, vertical: 18),
        backgroundColor: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
      ),
    );
  }

  Widget _buildSeccionMantenimientoSegundaFila() {
    return Row(
      children: [
        Expanded(
          child: _buildMantenimientoBotonCronograma(),
        ),
        const SizedBox(
          width: 20,
        ),
        const Expanded(
          flex: 1,
          child: SizedBox.shrink(),
        ),
        const SizedBox(
          width: 20,
        ),
        const Expanded(
          flex: 1,
          child: SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildMantenimientoBotonCronograma() {
    return ElevatedButton.icon(
      onPressed: () async {
        // controller.clearFields();
        // await controller.buscarActualizacionMasiva();
        // controller.isExpanded.value = false;
      },
      icon: const Icon(
        Icons.calendar_month,
        size: 18,
        color: Colors.white,
      ),
      label: const Text(
        "Cronograma de fechas disponibles",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 49, vertical: 18),
        backgroundColor: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
      ),
    );
  }

  Widget _buildSeccionSeguridad(
    BuildContext context,
  ) {
    return ExpansionTile(
      initiallyExpanded: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white),
      ),
      title: const Text(
        "Seguridad",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              _buildSeccionSeguridadPrimeraFila(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionSeguridadPrimeraFila() {
    return Row(
      children: [
        Expanded(
          child: _buildSeguridadBotonRoles(),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _buildSeguridadBotonUsuarios(),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _buildSeguridadBotonHistorialModificaciones(),
        ),
      ],
    );
  }

  Widget _buildSeguridadBotonRoles() {
    return ElevatedButton.icon(
      onPressed: () async {
        // controller.clearFields();
        // await controller.buscarActualizacionMasiva();
        // controller.isExpanded.value = false;
      },
      icon: const Icon(
        Icons.key,
        size: 18,
        color: Colors.white,
      ),
      label: const Text(
        "Roles y Permisos",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 49, vertical: 18),
        backgroundColor: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
      ),
    );
  }

  Widget _buildSeguridadBotonUsuarios() {
    return ElevatedButton.icon(
      onPressed: () async {
        // controller.clearFields();
        // await controller.buscarActualizacionMasiva();
        // controller.isExpanded.value = false;
      },
      icon: const Icon(
        Icons.person,
        size: 18,
        color: Colors.white,
      ),
      label: const Text(
        "Usuarios",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 49, vertical: 18),
        backgroundColor: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
      ),
    );
  }

  Widget _buildSeguridadBotonHistorialModificaciones() {
    return ElevatedButton.icon(
      onPressed: () async {
        // controller.clearFields();
        // await controller.buscarActualizacionMasiva();
        // controller.isExpanded.value = false;
      },
      icon: const Icon(
        Icons.history,
        size: 18,
        color: Colors.white,
      ),
      label: const Text(
        "Consulta de historial de modificaciones del sistema",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 49, vertical: 18),
        backgroundColor: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
      ),
    );
  }
}
