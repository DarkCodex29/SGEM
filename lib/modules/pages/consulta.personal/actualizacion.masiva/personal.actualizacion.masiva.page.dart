import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/shared/widgets/dynamic.table/dynamic.table.cabecera.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../shared/widgets/dropDown/custom.dropdown.global.dart';
import '../../../../shared/widgets/custom.textfield.dart';
import '../entrenamiento/modales/nuevo.modulo/entrenamiento.modulo.nuevo.dart';
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
          child: CustomDropdownGlobal(
            dropdownKey: 'guardia',
            hintText: 'Selecciona guardia',
            noDataHintText: 'No se encontraron guardias',
            controller: controller.dropdownController,
          ),
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
          child: CustomDropdownGlobal(
            dropdownKey: 'equipo',
            hintText: 'Selecciona equipo',
            noDataHintText: 'No se encontraron equipos',
            controller: controller.dropdownController,
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionConsultaTerceraFila(
      BuildContext context, ActualizacionMasivaController controller) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CustomDropdownGlobal(
            dropdownKey: 'modulo',
            hintText: 'Selecciona estado de avance',
            noDataHintText: 'No se encontraron estados de avance',
            controller: controller.dropdownController,
          ),
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

  Widget _buildBotonesAccion(ActualizacionMasivaController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            controller.clearFields();
            await controller.buscarActualizacionMasiva();
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
            await controller.buscarActualizacionMasiva();
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

  Widget _buildSeccionResultado(ActualizacionMasivaController controller) {
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
      ActualizacionMasivaController controller) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Entrenamientos",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSeccionResultadoTabla(ActualizacionMasivaController controller) {
    List<String> cabecera = [
      'Código MCP',
      'Nombres y Apellidos',
      'Guardia',
      'Equipo',
      'Estado de avance',
      'Nota práctica',
      'Nota teórica',
      'Fecha de examen',
      'Horas de entrenamiento acumuladas',
      'Fecha de inicio',
      'Fecha de término',
      'Acciones'
    ];

    return Obx(
      () {
        if (controller.entrenamientoResultados.isEmpty) {
          return const Center(child: Text("No se encontraron resultados"));
        }

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
      List<dynamic> data, ActualizacionMasivaController controller) {
    return SizedBox(
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          children: data.map((fila) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(child: Text(fila.codigoMcp!)),
                  Expanded(child: Text(fila.nombreCompleto!)),
                  Expanded(child: Text(fila.guardia!.nombre!)),
                  Expanded(child: Text(fila.equipo!.nombre!)),
                  Expanded(child: Text(fila.modulo!.nombre!)),
                  Expanded(
                      child: Text(
                    fila.inNotaPractica.toString(),
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    fila.inNotaTeorica.toString(),
                    textAlign: TextAlign.center,
                  )),
                  //Todo: Cambiar por fecha de examen
                  Expanded(
                    child: Text(DateFormat('dd/MM/yyyy')
                        .format(fila.fechaExamen as DateTime)),
                  ),
                  Expanded(
                      child: Text(
                    fila.inHorasAcumuladas.toString(),
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                    child: Text(
                        DateFormat('dd/MM/yyyy').format(fila.fechaInicio!)),
                  ),
                  Expanded(
                    child: Text(
                        DateFormat('dd/MM/yyyy').format(fila.fechaTermino!)),
                  ),
                  //Todo: Botones de accion
                  Expanded(
                    child: _buildIconButton(
                      Icons.edit,
                      AppTheme.primaryColor,
                      () async {
                        await showDialog(
                          context: Get.context!,
                          builder: (context) {
                            return GestureDetector(
                              child: Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: EntrenamientoModuloNuevo(
                                  isEdit: true,
                                  inEntrenamientoModulo: fila.key,
                                  //inEntrenamientoModulo: 20,
                                  onCancel: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                        //controller.showEditPersonal(personal);
                      },
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(
        icon,
        color: color,
        size: 24,
      ),
      onPressed: onPressed,
    );
  }
}
