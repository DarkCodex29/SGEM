import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/modules/pages/consulta.entrenamiento/consulta.entrenamiento.controller.dart';
import 'package:sgem/shared/widgets/dynamic.table/dynamic.table.cabecera.dart';
import '../../../config/theme/app_theme.dart';
import '../../../shared/widgets/dropDown/custom.dropdown.global.dart';
import '../../../shared/widgets/custom.textfield.dart';

class ConsultaEntrenamientoPage extends StatelessWidget {
  ConsultaEntrenamientoPage({super.key});

  final DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final ConsultaEntrenamientoController controller =
        Get.put(ConsultaEntrenamientoController());
    return Scaffold(
      body: _buildConsultaEntrenamiento(
        controller,
        context,
      ),
    );
  }

  Widget _buildConsultaEntrenamiento(
      ConsultaEntrenamientoController controller, BuildContext context) {
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
      BuildContext context, ConsultaEntrenamientoController controller) {
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

  Widget _buildSeccionConsultaPrimeraFila(
      ConsultaEntrenamientoController controller) {
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
          child: CustomDropdownGlobal(
            labelText: 'Equipo',
            dropdownKey: 'equipo',
            hintText: 'Selecciona equipo',
            noDataHintText: 'No se encontraron equipos',
            controller: controller.dropdownController,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: CustomDropdownGlobal(
            labelText: 'Modulo',
            dropdownKey: 'modulo',
            hintText: 'Selecciona modulo',
            noDataHintText: 'No se encontraron módulos',
            controller: controller.dropdownController,
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionConsultaSegundaFila(
      ConsultaEntrenamientoController controller) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CustomDropdownGlobal(
            labelText: 'Guardia',
            dropdownKey: 'guardiaFiltro',
            hintText: 'Selecciona guardia',
            noDataHintText: 'No se encontraron guardias',
            controller: controller.dropdownController,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: CustomDropdownGlobal(
            labelText: 'Estado de entrenamiento',
            dropdownKey: 'estadoEntrenamiento',
            hintText: 'Selecciona estado de entrenamiento',
            noDataHintText: 'No se encontraron capacitaciones',
            controller: controller.dropdownController,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: CustomDropdownGlobal(
            labelText: 'Condicion',
            dropdownKey: 'condicion',
            hintText: 'Selecciona condicion',
            noDataHintText: 'No se encontraron capacitaciones',
            controller: controller.dropdownController,
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionConsultaTerceraFila(
      BuildContext context, ConsultaEntrenamientoController controller) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CustomTextField(
            label: 'Rango de fecha',
            controller: controller.rangoFechaController,
            icon: const Icon(Icons.calendar_month),
            onIconPressed: () async {
              await controller.seleccionarFecha(context);
            },
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: CustomTextField(
            label: "Nombres y Apellidos del personal",
            controller: controller.nombresController,
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

  Widget _buildBotonesAccion(ConsultaEntrenamientoController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            controller.resetControllers();
            await controller.buscarEntrenamientos();
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
            await controller.buscarEntrenamientos();
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

  Widget _buildSeccionResultado(ConsultaEntrenamientoController controller) {
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

  Widget _buildSeccionResultadoBarraSuperior(
      ConsultaEntrenamientoController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Entrenamientos",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            await controller.downloadExcel();
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

  Widget _buildSeccionResultadoTabla(
      ConsultaEntrenamientoController controller) {
    List<String> cabecera = [
      'Código MCP',
      'Nombres y Apellidos',
      'Guardia',
      'Estado de entrenamiento',
      'Estado de avance',
      'Condicion',
      'Equipo',
      'Fecha de inicio',
      'Entrenador responsable',
      'Nota teorica',
      'Nota practica',
      'Horas acumuladas',
      'Horas operativas acumuladas'
    ];
    // if (controller.entrenamientoResultados.isEmpty) {
    //   return const Center(child: Text("No se encontraron resultados"));
    // }

    return Obx(
      () {
        var rowsToShow = controller.entrenamientoResultados
            .take(controller.rowsPerPage.value)
            .toList();

        return Column(
          children: [
            DynamicTableCabecera(cabecera: cabecera),
            _buildSeccionResultadoTablaData(rowsToShow, controller),
          ],
        );
      },
    );
  }

  Widget _buildSeccionResultadoTablaData(
      List<dynamic> data, ConsultaEntrenamientoController controller) {
    return SizedBox(
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          children: data.map((fila) {
            List<Widget> celdas = [
              Text(fila.codigoMcp),
              Text(fila.nombreCompleto),
              Text(fila.guardia.nombre!),
              Text(fila.estadoEntrenamiento.nombre!),
              Text(fila.modulo.nombre!),
              Text(fila.condicion.nombre!),
              Text(fila.equipo.nombre!),
              Text(DateFormat('dd/MM/yyyy').format(fila.fechaInicio!)),
              Text(fila.entrenador.nombre!),
              Text(fila.notaTeorica.toString()),
              Text(fila.notaPractica.toString()),
              Text(fila.horasAcumuladas.toString()),
              Text(fila.horasAcumuladas.toString()),
            ];
            return _buildFila(celdas);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFila(List<Widget> celdas) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
          children: celdas.map((celda) {
        return Expanded(flex: 1, child: celda);
      }).toList()),
    );
  }

  Widget _buildSeccionResultadoTablaPaginado(
      ConsultaEntrenamientoController controller) {
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
                    controller.buscarEntrenamientos(
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
                        controller.buscarEntrenamientos(
                            pageNumber: controller.currentPage.value,
                            pageSize: controller.rowsPerPage.value);
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
                            controller.currentPage.value++;
                            controller.buscarEntrenamientos(
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
}
