import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MaestroController extends GetxController {
  TextEditingController valorController = TextEditingController();

  RxBool isLoadingMaestro = false.obs;
  RxBool isLoadingEstado = false.obs;

  RxBool isExpanded = true.obs;
  RxnInt selectedMaestroKey = RxnInt();
  RxnInt selectedEstadoKey = RxnInt();

  var maestroOpciones = [].obs;
  var estadoOpciones = [].obs;
}
