import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_theme.dart';
import '../../../../shared/modules/maestro.detail.dart';
import '../../../../shared/modules/modulo.maestro.dart';
import '../../../../shared/widgets/custom.dropdown.dart';
import '../../../../shared/widgets/custom.textfield.dart';
import 'personal.actualizacion.masiva.controller.dart';

class PersonalActualizacionMasivaPage extends StatelessWidget {
  final VoidCallback onCancel;
   const PersonalActualizacionMasivaPage({super.key, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final ActualizacionMasivaController controller =
        Get.put(ActualizacionMasivaController());
    return Scaffold(
      body: _buildActualizacionMasiva(
        controller,
        context,
      ),
    );
  }

  Widget _buildActualizacionMasiva(
      ActualizacionMasivaController controller, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSeccionFiltros(context, controller),
              const SizedBox(
                height: 20,
              ),
              // _buildSeccionResultado(controller),
              // const SizedBox(
              //   height: 20,
              // ),
              _buildRegresarButton(context)
            ],
          ),
        );
      },
    );
  }

  Widget _buildSeccionFiltros(
      BuildContext context, ActualizacionMasivaController controller) {
    return ExpansionTile(
      initiallyExpanded: controller.isExpanded.value,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white),
      ),
      title: const Text(
        "Filtros de Busqueda",
        //"Actualización masiva de entrenamientos de personal entrenando",
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
              _buildSeccionConsultaPrimeraFila(controller),
              _buildSeccionConsultaSegundaFila(controller),
              _buildSeccionConsultaTerceraFila(context, controller),
              _buildBotonesAccion(controller)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionConsultaPrimeraFila(
      ActualizacionMasivaController controller) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CustomTextField(
            label: "Código MCP",
            controller: controller.codigoMcpController,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: CustomTextField(
            label: "Documento de identidad",
            controller: controller.codigoMcpController,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _buildDropdownGuardia(controller),
        ),
      ],
    );
  }

  Widget _buildSeccionConsultaSegundaFila(
      ActualizacionMasivaController controller) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CustomTextField(
            label: "Nombres Personal",
            controller: controller.codigoMcpController,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: CustomTextField(
            label: "Apellidos Personal",
            controller: controller.codigoMcpController,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _buildDropdownEquipo(controller),
        ),
      ],
    );
  }

  Widget _buildSeccionConsultaTerceraFila(
      BuildContext context, ActualizacionMasivaController controller) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildDropdownModulo(controller),
        ),
        const SizedBox(
          width: 20,
        ),
        const Expanded(
          flex:
              1, // El espacio estará vacío para que ocupe el espacio disponible
          child: SizedBox.shrink(),
        ),
        const SizedBox(
          width: 20,
        ),
        const Expanded(
          flex:
          1, // El espacio estará vacío para que ocupe el espacio disponible
          child: SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildBotonesAccion(ActualizacionMasivaController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            //controller.clearFields();
            //await controller.buscarEntrenamientos();
            controller.isExpanded.value = false;
          },
          icon: const Icon(
            Icons.cleaning_services,
            size: 18,
            color: AppTheme.primaryText,
          ),
          label: const Text(
            "Limpiar",
            style: TextStyle(fontSize: 16, color: AppTheme.primaryText),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 49, vertical: 18),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: AppTheme.alternateColor),
            ),
            elevation: 0,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () async {
            //await controller.buscarEntrenamientos();
            controller.isExpanded.value = true;
          },
          icon: const Icon(
            Icons.search,
            size: 18,
            color: Colors.white,
          ),
          label: const Text(
            "Buscar",
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
        ),
      ],
    );
  }

  Widget _buildDropdownGuardia(ActualizacionMasivaController controller) {
    return Obx(() {
      if (controller.guardiaOpciones.isEmpty) {
        return const SizedBox(
            height: 50, width: 50, child: CircularProgressIndicator());
      }
      List<MaestroDetalle> options = controller.guardiaOpciones;
      return CustomDropdown(
        hintText: 'Selecciona Guardia',
        options: options.map((option) => option.valor!).toList(),
        selectedValue: controller.selectedGuardiaKey.value != null
            ? options
                .firstWhere((option) =>
                    option.key == controller.selectedGuardiaKey.value)
                .valor
            : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.valor == value,
          );
          controller.selectedGuardiaKey.value = selectedOption.key;
          log('Guardia seleccionada - Key del Maestro: ${controller.selectedGuardiaKey.value}, Valor: $value');
        },
      );
    });
  }

  Widget _buildDropdownEquipo(ActualizacionMasivaController controller) {
    return Obx(() {
      if (controller.equipoOpciones.isEmpty) {
        return const SizedBox(
            height: 50, width: 50, child: CircularProgressIndicator());
      }
      List<MaestroDetalle> options = controller.equipoOpciones;
      return CustomDropdown(
        hintText: 'Selecciona Equipo',
        options: options.map((option) => option.valor!).toList(),
        selectedValue: controller.selectedEquipoKey.value != null
            ? options
                .firstWhere((option) =>
                    option.key == controller.selectedEquipoKey.value)
                .valor
            : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.valor == value,
          );
          controller.selectedEquipoKey.value = selectedOption.key;
          log('Equipo seleccionado - Key del Maestro: ${controller.selectedEquipoKey.value}, Valor: $value');
        },
      );
    });
  }

  Widget _buildDropdownModulo(ActualizacionMasivaController controller) {
    return Obx(() {
      if (controller.moduloOpciones.isEmpty) {
        return const SizedBox(
            height: 50, width: 50, child: CircularProgressIndicator());
      }
      List<ModuloMaestro> options = controller.moduloOpciones;
      return CustomDropdown(
        hintText: 'Selecciona estado de avance ',
        options: options.map((option) => option.modulo).toList(),
        selectedValue: controller.selectedModuloKey.value != null
            ? options
                .firstWhere((option) =>
                    option.key == controller.selectedModuloKey.value)
                .modulo
            : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.modulo == value,
          );
          controller.selectedModuloKey.value = selectedOption.key;
          log('Condicion seleccionada - Key del Maestro: ${controller.selectedModuloKey.value}, Valor: $value');
        },
      );
    });
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
