import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/api/api.maestro.detail.dart';
import '../../../shared/modules/maestro.detail.dart';

class CapacitacionController extends GetxController{
  TextEditingController codigoMcpController = TextEditingController();
  TextEditingController numeroDocumentoController = TextEditingController();

  RxBool isExpanded = true.obs;

  var selectedGuardiaKey = RxnInt();

  RxList<MaestroDetalle> guardiaOpciones = <MaestroDetalle>[].obs;
  final maestroDetalleService = MaestroDetalleService();

  @override
  void onInit() {

    super.onInit();
  }
}