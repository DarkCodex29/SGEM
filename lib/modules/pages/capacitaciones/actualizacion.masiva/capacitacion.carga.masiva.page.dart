import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/modules/pages/capacitaciones/actualizacion.masiva/capacitacion.carga.masiva.controller.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';

import '../../../../config/theme/app_theme.dart';
import '../../../../shared/widgets/dynamic.table/dynamic.table.cabecera.dart';

class CapacitacionCargaMasivaPage extends StatelessWidget {
  const CapacitacionCargaMasivaPage({super.key, required this.onCancel});
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final CapacitacionCargaMasivaController controller =
        Get.put(CapacitacionCargaMasivaController());
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
              _buildSeccionResultado(controller),
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

  Widget _buildSeccionResultado(CapacitacionCargaMasivaController controller) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSeccionResultadoBarraSuperior(controller),
          const SizedBox(
            height: 20,
          ),
          _buildSeccionResultadoTabla(controller),
          const SizedBox(
            height: 20,
          ),
          //_buildSeccionResultadoTablaPaginado(controller),
        ],
      ),
    );
  }

  Widget _buildSeccionResultadoBarraSuperior(
      CapacitacionCargaMasivaController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            controller.cargarArchivo();
          },
          icon: const Icon(
            Icons.attach_file,
            color: Colors.blue,
            size: 32,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: CustomTextField(
          label: "Archivo",
          controller: controller.archivoController,
        )),
        const SizedBox(
          width: 20,
        ),
        Row(
          children: _buildBotonesAccion(controller),
        ),
      ],
    );
  }

  Widget _buildSeccionResultadoTabla(
      CapacitacionCargaMasivaController controller) {
    List<String> cabecera = [
      'Código MCP',
      'DNI',
      'Nombres y apellidos',
      'Guardia',
      'Entrenador responsable',
      'Nombre capacitación',
      'Categoría',
      'Empresa de capacitación',
      'Fecha de inicio',
      'Fecha de término',
      'Horas',
      'Nota teórica',
      'Nota práctica',
    ];
    // if (controller.entrenamientoResultados.isEmpty) {
    //   return const Center(child: Text("No se encontraron resultados"));
    // }

    return Obx(
      () {
         var rowsToShow = controller.actualizacionMasivaResultados
             .take(controller.rowsPerPage.value)
             .toList();

        return Column(
          children: [
            DynamicTableCabecera(cabecera: cabecera),
            //_buildSeccionResultadoTablaData(rowsToShow, controller),
          ],
        );
      },
    );
  }

  List<Widget> _buildBotonesAccion(
      CapacitacionCargaMasivaController controller) {
    return [
      ElevatedButton.icon(
        onPressed: () {
          //controller.showActualizacionMasiva();
        },
        icon: const Icon(
          Icons.upload_rounded,
          size: 18,
          color: AppTheme.infoColor,
        ),
        label: const Text(
          "Previsualizar carga",
          style: TextStyle(fontSize: 16, color: AppTheme.infoColor),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          backgroundColor: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: AppTheme.primaryColor),
          ),
        ),
      ),
      const SizedBox(width: 10),
      ElevatedButton.icon(
        onPressed: () {
          //controller.showNewPersonal();
        },
        icon: const Icon(
          Icons.download_rounded,
          size: 18,
          color: AppTheme.primaryBackground,
        ),
        label: const Text(
          "Descargar plantilla",
          style: TextStyle(fontSize: 16, color: AppTheme.primaryBackground),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: AppTheme.primaryColor),
          ),
        ),
      ),
    ];
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
