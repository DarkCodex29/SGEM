import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.monitoring.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/shared/modules/monitoring.save.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/widgets/alert/widget.alert.dart';
import 'package:sgem/shared/widgets/save/widget.save.personal.confirmation.dart';

class CreateMonitoringController extends GetxController {
  final monitoringService = MonitoringService();
  final PersonalService personalService = PersonalService();
  final codigoMCPController = TextEditingController();
  final codigoMCP2Controller = TextEditingController();
  final fullNameController = TextEditingController();
  final guardController = TextEditingController();
  final stateTrainingController = TextEditingController();
  final moduleController = TextEditingController();
  final fechaProximoMonitoreoController = TextEditingController();
  final fechaRealMonitoreoController = TextEditingController();
  final horasController = TextEditingController();
  final modelMonitoring = MonitoingSave(
      inTipoActividad: 0,
      inTipoPersona: 0,
      //inPersona: selectedPersonKey.value,
      inPersona: 0,
      inEquipo: 0,
      inEntrenador: 0,
      inCondicion: 0,
      inTotalHoras: 0,
      estadoEntrenamiento: OptionValue());

  RxBool isLoadingCodeMcp = false.obs;
  RxBool isSaving = false.obs;
  RxBool isLoandingSave = false.obs;
  Rxn<Uint8List?> personalPhoto = Rxn<Uint8List?>();

  var selectedEquipoKey = RxnInt();
  var selectedEntrenadorKey = RxnInt();
  var selectedModuloKey = RxnInt();
  var selectedGuardiaKey = RxnInt();
  var selectedEstadoEntrenamientoKey = RxnInt();
  var selectedCondicionKey = RxnInt();
  var selectedPersonKey = RxnInt();

  clearModel() {
    modelMonitoring ==
        MonitoingSave(
          inTipoActividad: 0,
          inTipoPersona: 0,
          //inPersona: selectedPersonKey.value,
          inPersona: 0,
          inEquipo: 0,
          inEntrenador: 0,
          inCondicion: 0,
          inTotalHoras: 0,
          estadoEntrenamiento: OptionValue(),
        );
  }

  Future<bool> saveMonitoring(BuildContext context) async {
    bool state = false;
    try {
      modelMonitoring.inPersona = 1;
      modelMonitoring.inEquipo = selectedEquipoKey.value;
      modelMonitoring.inEquipo = selectedEquipoKey.value;
      modelMonitoring.inEntrenador = selectedEntrenadorKey.value;
      modelMonitoring.inCondicion = selectedCondicionKey.value;
      modelMonitoring.fechaProximoMonitoreo =
          DateTime.parse(fechaProximoMonitoreoController.text);
      modelMonitoring.fechaRealMonitoreo =
          DateTime.parse(fechaRealMonitoreoController.text);
      modelMonitoring.inTotalHoras = int.parse(horasController.text);

      final response =
          await monitoringService.registerMonitoring(modelMonitoring);
      if (response.success) {
        // ignore: use_build_context_synchronously
        _mostrarMensajeGuardado(context);
        clearModel();
        state = true;
      } else {
        _mostrarErroresValidacion(Get.context!, ['Error al guardar monitoreo']);
      }
    } catch (e) {
      log('Error: $e');
    } finally {
      isLoandingSave.value = false;
    }
    return state;
  }

  Future<bool> deleteMonitoring(BuildContext context) async {
    bool state = false;
    try {
      final response =
          await monitoringService.deleteMonitoring(modelMonitoring);
      if (response.success) {
        _mostrarMensajeGuardado(
          // ignore: use_build_context_synchronously
          context,
          title: "Monitoreo Eliminado",
        );
        state = true;
        clearModel();
      } else {
        _mostrarErroresValidacion(
            Get.context!, ['Error al Eliminar monitoreo']);
      }
    } catch (e) {
      log('Error: $e');
    } finally {
      isLoandingSave.value = false;
    }
    return state;
  }

  Future<void> searchPersonByCodeMcp() async {
    if (codigoMCPController.text.isEmpty) {
      _mostrarErroresValidacion(
          Get.context!, ['Ingrese un Código MCP válido.']);
      resetInfoPerson();
      return;
    }
    try {
      isLoadingCodeMcp.value = true;
      final responseListar = await personalService.listarPersonalEntrenamiento(
        codigoMcp: codigoMCPController.text,
      );
      if ((responseListar.data == null || responseListar.data!.isEmpty)) {
        _mostrarErroresValidacion(
            Get.context!, ['No hay infromación para mostar.']);
      }
      setInfoPerson(responseListar.data!.first);
      loadPersonalPhoto(responseListar.data!.first.key);
    } catch (e) {
      log('Error inesperado al buscar el personal: $e');
    } finally {
      isLoadingCodeMcp.value = false;
    }
  }

  Future<void> loadPersonalPhoto(int idOrigen) async {
    try {
      final photoResponse =
          await personalService.obtenerFotoPorCodigoOrigen(idOrigen);

      if (photoResponse.success && photoResponse.data != null) {
        personalPhoto.value = photoResponse.data;
      } else {
        log('Error al cargar la foto: ${photoResponse.message}');
      }
    } catch (e) {
      log('Error al cargar la foto del personal: $e');
    }
  }

  setInfoPerson(Personal person) {
    codigoMCP2Controller.text = person.codigoMcp;
    fullNameController.text =
        "${person.apellidoPaterno} ${person.apellidoMaterno} ${person.segundoNombre}";
    guardController.text = person.guardia.nombre;
    stateTrainingController.text = "";
    moduleController.text = "";
    selectedPersonKey.value = person.inPersonalOrigen;
  }

  resetInfoPerson() {
    codigoMCP2Controller.text = "";
    fullNameController.text = "";
    guardController.text = "";
    stateTrainingController.text = "";
    moduleController.text = "";
  }

  void _mostrarMensajeGuardado(BuildContext context,
      {String title = "Los datos se guardaron \nsatisfactoriamente"}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MensajeGuardadoWidget(
          title: title,
        );
      },
    );
  }

  void _mostrarErroresValidacion(BuildContext context, List<String> errores) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MensajeValidacionWidget(errores: errores);
      },
    );
  }
}
