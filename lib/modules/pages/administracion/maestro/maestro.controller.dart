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
  var maestroResultado = [].obs;

  var rowsPerPage = 10.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalRecords = 0.obs;
}
