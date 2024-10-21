import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/modules/pages/capacitaciones/capacitacion.controller.dart';


import '../../../config/theme/app_theme.dart';
import '../../../shared/modules/maestro.detail.dart';
import '../../../shared/modules/personal.dart';
import '../../../shared/widgets/custom.dropdown.dart';
import '../../../shared/widgets/custom.textfield.dart';
import 'nueva capacitación/nueva.capacitacion.page.dart';

class CapacitacionPage extends StatelessWidget {
  CapacitacionPage({super.key, required this.onCancel});
  final VoidCallback onCancel;
  final DateTime today = DateTime.now();
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
              _buildSeccionResultado(controller),
              // const SizedBox(
              //   height: 20,
              // ),
              // _buildRegresarButton(context)
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
              _buildSeccionConsultaSegundaFila(controller),
              _buildSeccionConsultaTerceraFila(context, controller),
              _buildSeccionConsultaCuartaFila(context, controller),
              _buildBotonesAccion(controller)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionResultado(CapacitacionController controller) {
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
          _buildSeccionResultadoTablaPaginado(controller),
        ],
      ),
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

  Widget _buildSeccionConsultaSegundaFila(CapacitacionController controller) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CustomTextField(
            label: "Nombres",
            controller: controller.nombresController,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: CustomTextField(
            label: "Apellido Paterno",
            controller: controller.apellidoPaternoController,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: CustomTextField(
            label: "Apellido Materno",
            controller: controller.apellidoMaternoController,
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionConsultaTerceraFila(
      BuildContext context, CapacitacionController controller) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildDropdownNombreCapacitacion(controller),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _buildDropdownCategoria(controller),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: _buildDropdownEmpresaCapacitacion(controller),
        ),
      ],
    );
  }

  Widget _buildSeccionConsultaCuartaFila(
      BuildContext context, CapacitacionController controller) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: _buildDropdownEntrenador(controller),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          flex: 1,
          child: CustomTextField(
            label: 'Rango de fecha',
            controller: controller.rangoFechaController,
            icon: const Icon(Icons.calendar_month),
            onIconPressed: () {
              _selectDateRange(context, controller);
            },
          ),
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

  Widget _buildDropdownGuardia(CapacitacionController controller) {
    return Obx(() {
      if (controller.isLoadingGuardia.value) {
        return const Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        );
      }
      if (controller.guardiaOpciones.isEmpty) {
        return const Center(
          child: Text(
            'No se encontraron guardias',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        );
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

  Widget _buildDropdownNombreCapacitacion(CapacitacionController controller) {
    return Obx(() {
      if (controller.isLoadingCapacitacion.value) {
        return const Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        );
      }
      if (controller.capacitacionOpciones.isEmpty) {
        return const Center(
          child: Text(
            'No se encontraron capacitaciones',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        );
      }
      List<MaestroDetalle> options = controller.capacitacionOpciones;
      return CustomDropdown(
        hintText: 'Nombre de capacitacion',
        options: options.map((option) => option.valor!).toList(),
        selectedValue: controller.selectedCapacitacionKey.value != null
            ? options
                .firstWhere((option) =>
                    option.key == controller.selectedCapacitacionKey.value)
                .valor
            : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.valor == value,
          );
          controller.selectedCapacitacionKey.value = selectedOption.key;
          log('Guardia seleccionada - Key del Maestro: ${controller.selectedCapacitacionKey.value}, Valor: $value');
        },
      );
    });
  }

  Widget _buildDropdownCategoria(CapacitacionController controller) {
    return Obx(() {
      if (controller.isLoadingCategoria.value) {
        return const Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.categoriaOpciones.isEmpty) {
        return const Center(
          child: Text(
            'No se encontraron categorias',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        );
      }
      List<MaestroDetalle> options = controller.categoriaOpciones;
      return CustomDropdown(
        hintText: 'Categoria',
        options: options.map((option) => option.valor!).toList(),
        selectedValue: controller.selectedCategoriaKey.value != null
            ? options
                .firstWhere((option) =>
                    option.key == controller.selectedCategoriaKey.value)
                .valor
            : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.valor == value,
          );
          controller.selectedCategoriaKey.value = selectedOption.key;
          log('Guardia seleccionada - Key del Maestro: ${controller.selectedCategoriaKey.value}, Valor: $value');
        },
      );
    });
  }

  Widget _buildDropdownEmpresaCapacitacion(CapacitacionController controller) {
    return Obx(() {
      if (controller.isLoadingEmpresaCapacitacion.value) {
        return const Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.empresaCapacitacionOpciones.isEmpty) {
        return const Center(
          child: Text(
            'No se encontraron empresa capacitacion',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        );
      }
      List<MaestroDetalle> options = controller.empresaCapacitacionOpciones;
      return CustomDropdown(
        hintText: 'Empresa de capacitacion',
        options: options.map((option) => option.valor!).toList(),
        selectedValue: controller.selectedEmpresaCapacitacionKey.value != null
            ? options
                .firstWhere((option) =>
                    option.key ==
                    controller.selectedEmpresaCapacitacionKey.value)
                .valor
            : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.valor == value,
          );
          controller.selectedEmpresaCapacitacionKey.value = selectedOption.key;
          log('Guardia seleccionada - Key del Maestro: ${controller.selectedEmpresaCapacitacionKey.value}, Valor: $value');
        },
      );
    });
  }

  Widget _buildDropdownEntrenador(CapacitacionController controller) {
    return Obx(() {
      if (controller.isLoadingEntrenador.value) {
        return const Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.entrenadorOpciones.isEmpty) {
        return const Center(
          child: Text(
            'No se encontraron entrenadores',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        );
      }
      List<Personal> options = controller.entrenadorOpciones;
      return CustomDropdown(
        hintText: 'Entrenador responsable',
        options: options.map((option) => option.nombreCompleto).toList(),
        selectedValue: controller.selectedEntrenadorKey.value != null
            ? options
                .firstWhere((option) =>
                    option.inPersonalOrigen == controller.selectedEntrenadorKey.value)
                .nombreCompleto
            : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.nombreCompleto == value,
          );
          controller.selectedEntrenadorKey.value = selectedOption.inPersonalOrigen;
          log('Entrenador seleccionada - Key del Maestro: ${controller.selectedEntrenadorKey.value}, Valor: $value');
        },
      );
    });
  }

  Widget _buildBotonesAccion(CapacitacionController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            controller.clearFields();
           await controller.buscarCapacitaciones();
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
            await controller.buscarCapacitaciones();
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

  Future<void> _selectDateRange(
      BuildContext context, CapacitacionController controller) async {
    DateTimeRange selectedDateRange = DateTimeRange(
      start: today.subtract(const Duration(days: 30)),
      end: today,
    );

    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      barrierColor: Colors.blueAccent,
      initialDateRange: selectedDateRange,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendar,
    );

    if (picked != null && picked != selectedDateRange) {
      controller.rangoFechaController.text =
          '${DateFormat('dd/MM/yyyy').format(picked.start)} - ${DateFormat('dd/MM/yyyy').format(picked.end)}';
      controller.fechaInicio = picked.start;
      controller.fechaTermino = picked.end;
    }
  }

  Widget _buildSeccionResultadoBarraSuperior(
      CapacitacionController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Capacitaciones",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: SizedBox.shrink(),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () {
            // controller.showActualizacionMasiva();
          },
          icon: const Icon(
            Icons.refresh,
            size: 18,
            color: AppTheme.infoColor,
          ),
          label: const Text(
            "Carga masiva",
            style: TextStyle(fontSize: 16, color: AppTheme.infoColor),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            backgroundColor: AppTheme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: AppTheme.primaryColor),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () async {
            //await controller.downloadExcel();
          },
          icon: const Icon(Icons.download,
              size: 18, color: AppTheme.primaryColor),
          label: const Text(
            "Descargar Excel",
            style: TextStyle(fontSize: 16, color: AppTheme.primaryColor),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            backgroundColor: Colors.white,
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
            Get.to(() => const NuevaCapacitacionPage());
          },
          icon: const Icon(Icons.add,
              size: 18, color: AppTheme.primaryBackground),
          label: const Text(
            "Nueva capacitacion",
            style: TextStyle(fontSize: 16, color: AppTheme.primaryBackground),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: AppTheme.primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionResultadoTabla(CapacitacionController controller) {
    return Obx(
      () {
        if (controller.isLoadingCapacitacionResultados.value) {
          return const Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (controller.capacitacionResultados.isEmpty) {
          return const Center(child: Text("No se encontraron resultados"));
        }

        var rowsToShow = controller.capacitacionResultados
            .take(controller.rowsPerPage.value)
            .toList();

        return Column(
          children: [
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 16.0,
              ),
              child: _buildSeccionResultadoTablaCabezera(),
            ),
            SizedBox(
              height: 500,
              child: SingleChildScrollView(
                child: Column(
                  children: rowsToShow.map((entrenamiento) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(flex: 1 ,child: Text(entrenamiento.codigoMcp!)),
                          Expanded(flex: 1 ,child: Text(entrenamiento.numeroDocumento!)),
                          Expanded(flex: 1 ,child: Text(entrenamiento.nombreCompleto!)),
                          Expanded(flex: 1 ,child: Text(entrenamiento.guardia.nombre!,textAlign: TextAlign.center,)),
                          Expanded(flex: 1 ,
                              child: Text(
                                  entrenamiento.entrenador.nombre!)),
                          Expanded(flex: 1 ,child: Text(entrenamiento.categoria.nombre!)),
                          Expanded(flex: 1 ,
                              child: Text(entrenamiento.empresaCapacitadora.nombre!)),
                          Expanded(flex: 1 ,
                            child: Text(DateFormat('dd/MM/yyyy')
                                .format(entrenamiento.fechaInicio!)),
                          ),
                          Expanded(flex: 1 ,
                            child: Text(DateFormat('dd/MM/yyyy')
                                .format(entrenamiento.fechaTermino!) ,textAlign: TextAlign.center,),
                          ),
                          Expanded(flex: 1 ,
                              child: Text(entrenamiento.inTotalHoras.toString(), textAlign: TextAlign.center,)),
                          Expanded(flex: 1 ,
                              child: Text(
                            entrenamiento.inNotaTeorica.toString(),
                            textAlign: TextAlign.center,
                          )),
                          Expanded(flex: 1 ,
                              child: Text(
                            entrenamiento.inNotaPractica.toString(),
                            textAlign: TextAlign.center,
                          )),
                          const Expanded(flex: 1 ,
                              child: Text(
                            'Acciones',
                            textAlign: TextAlign.center,
                          )),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSeccionResultadoTablaCabezera() {
    return const Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            'Código MCP',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'DNI',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Nombres y Apellidos',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Guardia',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Entrenador responsable',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Categoria',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Empresa de capacitacion',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Fecha de inicio',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Fecha de termino',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Horas',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Nota teorica',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Nota practica',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Acciones',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionResultadoTablaPaginado(
      CapacitacionController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() => Text(
              'Mostrando ${controller.currentPage.value * controller.rowsPerPage.value - controller.rowsPerPage.value + 1} - '
              '${controller.currentPage.value * controller.rowsPerPage.value > controller.totalRecords.value ? controller.totalRecords.value : controller.currentPage.value * controller.rowsPerPage.value} '
              'de ${controller.totalRecords.value} registros',
              style: const TextStyle(fontSize: 14),
            )),
        Obx(
          () => Row(
            children: [
              const Text("Items por página: "),
              DropdownButton<int>(
                value: controller.rowsPerPage.value > 0 &&
                        controller.rowsPerPage.value <= 50
                    ? controller.rowsPerPage.value
                    : null,
                items: [10, 20, 50]
                    .map((value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  // if (value != null) {
                  //   controller.rowsPerPage.value = value;
                  //   controller.currentPage.value = 1;
                  //   controller.searchPersonal(
                  //       pageNumber: controller.currentPage.value,
                  //       pageSize: value);
                  // }
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: controller.currentPage.value > 1
                    ? () {
                        // controller.currentPage.value--;
                        // controller.searchPersonal(
                        //     pageNumber: controller.currentPage.value,
                        //     pageSize: controller.rowsPerPage.value);
                      }
                    : null,
              ),
              Text(
                  '${controller.currentPage.value} de ${controller.totalPages.value}'),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed:
                    controller.currentPage.value < controller.totalPages.value
                        ? () {
                            // controller.currentPage.value++;
                            // controller.searchPersonal(
                            //     pageNumber: controller.currentPage.value,
                            //     pageSize: controller.rowsPerPage.value);
                          }
                        : null,
              ),
            ],
          ),
        ),
      ],
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
