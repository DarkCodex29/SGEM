import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';

enum MonitoringSearchScreen {
  none,
  newMonitoring,
  editMonitoring,
  trainingForm,
  viewMonitoring,
  carnetMonitoring,
  diplomaMonitoring,
  certificadoMonitoring,
  actualizacionMasiva
}

extension MonitoringSearchScreenExtension on MonitoringSearchScreen {
  String description() {
    switch (this) {
      case MonitoringSearchScreen.none:
        return "";
      case MonitoringSearchScreen.newMonitoring:
        return "Nuevo Monitoring a Entrenar";
      case MonitoringSearchScreen.editMonitoring:
        return "Editar Monitoring";
      case MonitoringSearchScreen.trainingForm:
        return "Búsqueda de entrenamiento de Monitoring";
      case MonitoringSearchScreen.viewMonitoring:
        return "Visualizar";
      case MonitoringSearchScreen.carnetMonitoring:
        return "Carnet del Monitoring";
      case MonitoringSearchScreen.actualizacionMasiva:
        return "Actualizacion Masiva";
      default:
        return "Entrenamientos";
    }
  }
}

class MonitoringSearchController extends GetxController {
  final codigoMCPController = TextEditingController();
  final documentoIdentidadController = TextEditingController();
  final nombresController = TextEditingController();
  final apellidosMaternoController = TextEditingController();
  final apellidosPaternoController = TextEditingController();
  var screen = MonitoringSearchScreen.none.obs;
  var isExpanded = true.obs;
  RxList<MaestroDetalle> guardiaOptions = <MaestroDetalle>[].obs;
}
