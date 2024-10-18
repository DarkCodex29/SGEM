import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/modules/pages/capacitaciones/capacitacion.controller.dart';

import '../../../shared/modules/maestro.detail.dart';
import '../../../shared/widgets/custom.dropdown.dart';
import '../../../shared/widgets/custom.textfield.dart';

class CapacitacionPage extends StatelessWidget {
  const CapacitacionPage({super.key});

  @override
  Widget build(BuildContext context) {
    CapacitacionController controller = Get.put(CapacitacionController());
    return Scaffold(
      body: _buildCapacitacionPage(
        controller,
        context,
      ),
    );
  }

  Widget _buildCapacitacionPage(
      CapacitacionController controller, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSeccionConsulta(context, controller),
              const SizedBox(
                height: 20,
              ),
              //_buildSeccionResultado(controller),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSeccionConsulta(
      BuildContext context, CapacitacionController controller) {
    return ExpansionTile(
      initiallyExpanded: controller.isExpanded.value,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white),
      ),
      title: const Text(
        "Busqueda de Capacitaciones",
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
              // _buildSeccionConsultaSegundaFila(controller),
              // _buildSeccionConsultaTerceraFila(context, controller),
              // _buildBotonesAccion(controller)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionConsultaPrimeraFila(CapacitacionController controller) {
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
            label: "DNI",
            controller: controller.numeroDocumentoController,
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
  Widget _buildDropdownGuardia(CapacitacionController controller) {
    return Obx(() {
      if (controller.guardiaOpciones.isEmpty) {
        return const SizedBox(
            height: 50, width: 50, child: LinearProgressIndicator(backgroundColor: Colors.white,));
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

}
