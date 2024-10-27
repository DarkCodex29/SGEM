import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.monitoring.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/shared/modules/monitoring.save.dart';
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

  Future<void> saveMonitoring(BuildContext context) async {
    try {
      final response =
          await monitoringService.registerMonitoring(setModelMonitoring());
      if (response.success) {
        // ignore: use_build_context_synchronously
        _mostrarMensajeGuardado(context);
      } else {
        _mostrarErroresValidacion(Get.context!, ['Error al guardar monitoreo']);
      }
    } catch (e) {
      log('Error: $e');
    } finally {
      isLoandingSave.value = false;
    }
  }

  MonitoingSave setModelMonitoring() {
    return MonitoingSave(
      inTipoActividad: 3,
      inTipoPersona: 1,
      inPersona: selectedPersonKey.value,
      inEquipo: selectedEquipoKey.value,
      inEntrenador: selectedEntrenadorKey.value,
      inCondicion: selectedCondicionKey.value,
      fechaProximoMonitoreo:
          DateTime.parse(fechaProximoMonitoreoController.text),
      fechaRealMonitoreo: DateTime.parse(fechaRealMonitoreoController.text),
      inTotalHoras: int.parse(horasController.text),
    );
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
    selectedPersonKey.value=person.inPersonalOrigen;
  }

  resetInfoPerson() {
    codigoMCP2Controller.text = "";
    fullNameController.text = "";
    guardController.text = "";
    stateTrainingController.text = "";
    moduleController.text = "";
  }

  void _mostrarMensajeGuardado(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const MensajeGuardadoWidget();
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
