import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/api/api.maestro.detail.dart';
import '../../../shared/modules/maestro.detail.dart';

class CapacitacionController extends GetxController {
  TextEditingController codigoMcpController = TextEditingController();
  TextEditingController numeroDocumentoController = TextEditingController();
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidoPaternoController = TextEditingController();
  TextEditingController apellidoMaternoController = TextEditingController();
  TextEditingController rangoFechaController = TextEditingController();

  DateTime? fechaInicio;
  DateTime? fechaTermino;

  RxBool isExpanded = true.obs;

  var selectedGuardiaKey = RxnInt();

  RxList<MaestroDetalle> guardiaOpciones = <MaestroDetalle>[].obs;
  final maestroDetalleService = MaestroDetalleService();
  RxList capacitacionResultados =[].obs;

  var rowsPerPage = 10.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalRecords = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void clearFields(){

  }
}
