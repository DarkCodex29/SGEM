import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/shared/modules/capacitacion.carga.masiva.resultado.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../shared/widgets/dynamic.table/dynamic.table.cabecera.dart';
import 'capacitacion.carga.masiva.controller.dart';

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
          _buildSeccionResultadoTablaPaginado(controller),
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
        var rowsToShow = controller.cargaMasivaResultados
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
      List<CapacitacionCargaMasivaResultado> data,
      CapacitacionCargaMasivaController controller) {
    return SizedBox(
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          children: data.map((fila) {
            List<Widget> celdas = [
              Text(fila.codigo),
              Text(fila.dni),
              Text(fila.nombres),
              Text(fila.guardia),
              Text(fila.entrenador),
              Text(fila.nombreCapacitacion),
              Text(fila.categoria),
              Text(fila.empresa),
              Text(fila.fechaInicio != null
                  ? _formatDate(fila.fechaInicio!)
                  : ''),
              Text(fila.fechaTermino != null
                  ? _formatDate(fila.fechaTermino!)
                  : ''),
              Text(fila.horas?.toString() ?? ''),
              Text(fila.notaTeorica?.toString() ?? ''),
              Text(fila.notaPractica?.toString() ?? ''),
            ];
            return _buildFila(celdas);
          }).toList(),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
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

  List<Widget> _buildBotonesAccion(
      CapacitacionCargaMasivaController controller) {
    return [
      ElevatedButton.icon(
        onPressed: () {
          controller.previsualizarCarga();
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

  Widget _buildSeccionResultadoTablaPaginado(
      CapacitacionCargaMasivaController controller) {
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
                    controller.currentPage.value = 1; // Reiniciar a la primera página
                    // Recalcular el total de páginas
                    controller.totalPages.value = (controller.totalRecords.value / controller.rowsPerPage.value).ceil();
                    controller.goToPage(1); // Mostrar la primera página
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: controller.currentPage.value > 1
                    ? () {
                        controller
                            .previousPage();
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
                            controller.nextPage();
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
