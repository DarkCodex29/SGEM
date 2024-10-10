import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/modules/pages/trainings/trainings.controller.dart';

import '../../../config/theme/app_theme.dart';
import '../../../shared/widgets/custom.dropdown.dart';
import '../../../shared/widgets/custom.textfield.dart';

class TrainingsPage extends StatelessWidget {
  TrainingsPage({super.key});

  final DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final TrainingsController controller = Get.put(TrainingsController());
    return Scaffold(
      body: _buildConsultaEntrenamiento(
        controller,
        context,
      ),
    );
  }

  Widget _buildConsultaEntrenamiento(
      TrainingsController controller, BuildContext context) {
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildSeccionConsulta(
      BuildContext context, TrainingsController controller) {
    return ExpansionTile(
      initiallyExpanded: controller.isExpanded.value,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white),
      ),
      title: const Text(
        "Consulta de Entrenamiento",
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

  Widget _buildSeccionConsultaPrimeraFila(TrainingsController controller) {
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
          child: CustomDropdown(
            hintText: "Equipo",
            options: const ["A", "B", "C"],
            isSearchable: false,
            onChanged: (value) {},
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: CustomDropdown(
            hintText: "Estado de avance",
            options: const ["A", "B", "C"],
            isSearchable: false,
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionConsultaSegundaFila(TrainingsController controller) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CustomDropdown(
            hintText: "Guardia",
            options: const ["A", "B", "C"],
            isSearchable: false,
            onChanged: (value) {},
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: CustomDropdown(
            hintText: "Estado de Entrenamiento",
            options: const ["A", "B", "C"],
            isSearchable: false,
            onChanged: (value) {},
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: CustomDropdown(
            hintText: "Condicion",
            options: const ["A", "B", "C"],
            isSearchable: false,
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionConsultaTerceraFila(
      BuildContext context, TrainingsController controller) {
    return Row(
      children: <Widget>[
        Expanded(
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
        Expanded(
          child: CustomTextField(
            label: "Nombres y Apellidos del personal",
            controller: controller.codigoMcpController,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        const Expanded(
          flex: 1, // El espacio estará vacío para que ocupe solo la mitad
          child: SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildBotonesAccion(TrainingsController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            controller.clearFields();
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
            // await controller.searchPersonal();
            controller.isExpanded.value = false;
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
      BuildContext context, TrainingsController controller) async {
    DateTimeRange selectedDateRange = DateTimeRange(
      start: today.subtract(const Duration(days: 30)),
      end: today,
    );

    DateTimeRange? picked = await showDateRangePicker(
      context: context,
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

  Widget _buildSeccionResultado(TrainingsController controller) {
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
          _buildSeccionResultadoBarraSuperior(),
          const SizedBox(
            height: 20,
          ),
          _buildSeccionResultadoTabla(controller),
        ],
      ),
    );
  }

  Widget _buildSeccionResultadoBarraSuperior() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Entrenamientos",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
      ],
    );
  }

  Widget _buildSeccionResultadoTabla(TrainingsController controller) {
    var rowsToShow = controller.entrenamientosResultado
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
                return  Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(child: Text(entrenamiento)),
                      Expanded(child: Text(entrenamiento)),
                      Expanded(child: Text(entrenamiento)),
                      Expanded(child: Text(entrenamiento)),
                      Expanded(child: Text(entrenamiento)),
                      Expanded(child: Text(entrenamiento)),
                      Expanded(child: Text(entrenamiento)),
                      Expanded(child: Text(entrenamiento)),
                      Expanded(child: Text(entrenamiento)),
                      Expanded(child: Text(entrenamiento)),
                      Expanded(child: Text(entrenamiento)),
                      Expanded(child: Text(entrenamiento)),
                      Expanded(child: Text(entrenamiento)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
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
            'Estado de entrenamiento',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Estado de avance',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Condicion',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Equipo',
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
            'Entrenador responsable',
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
            'Horas acumuladas',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Horas operativas acumuladas',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  /*
  Widget _buildSeccionResultadoTablaPaginado(TrainingsController controller){
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
                  if (value != null) {
                    controller.rowsPerPage.value = value;
                    controller.currentPage.value = 1;
                    controller.searchPersonal(
                        pageNumber: controller.currentPage.value,
                        pageSize: value);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: controller.currentPage.value > 1
                    ? () {
                  controller.currentPage.value--;
                  controller.searchPersonal(
                      pageNumber: controller.currentPage.value,
                      pageSize: controller.rowsPerPage.value);
                }
                    : null,
              ),
              Text(
                  '${controller.currentPage.value} de ${controller.totalPages.value}'),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: controller.currentPage.value <
                    controller.totalPages.value
                    ? () {
                  controller.currentPage.value++;
                  controller.searchPersonal(
                      pageNumber: controller.currentPage.value,
                      pageSize: controller.rowsPerPage.value);
                }
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
     */
}
