import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/shared/widgets/dynamic.table/dynamic.table.cabecera.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../shared/widgets/dropDown/custom.dropdown.dart';
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
          child: CustomDropdown(
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
          child: CustomDropdown(
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
          child: CustomDropdown(
            dropdownKey: 'modulo',
            hintText: 'Selecciona estado de avance',
            noDataHintText: 'No se encontraron estados de avance',
            controller: controller.moduloDropdownController,
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

/*
  Widget _buildDropdownGuardia(ActualizacionMasivaController controller) {
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

  Widget _buildDropdownEquipo(ActualizacionMasivaController controller) {
    return Obx(() {
      if (controller.equipoOpciones.isEmpty) {
        return const SizedBox(
            height: 50,
            width: 50,
            child: LinearProgressIndicator(
              backgroundColor: Colors.white,
            ));
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

  Widget _buildDropdownMohdulo(ActualizacionMasivaController controller) {
    return Obx(() {
      if (controller.moduloOpciones.isEmpty) {
        return const SizedBox(
            height: 50,
            width: 50,
            child: LinearProgressIndicator(
              backgroundColor: Colors.white,
            ));
      }
      List<ModuloMaestro> options = controller.moduloOpciones;
      return CustomDropdown(
        hintText: 'Selecciona estado de avance ',
        options: options.map((option) => option.modulo!).toList(),
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
*/
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
    const boldTextStyle = TextStyle(fontWeight: FontWeight.bold);

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
                        final bool? success = await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          enableDrag: false,
                          context: Get.context!,
                          builder: (context) {
                            return GestureDetector(
                              onTap: () => FocusScope.of(context).unfocus(),
                              child: Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: EntrenamientoModuloNuevo(
                                  isEdit: true,
                                  //inEntrenamientoModulo: fila.key,
                                  inEntrenamientoModulo: 20,
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
