import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrainingsController extends GetxController{
  TextEditingController codigoMcpController = TextEditingController();
  TextEditingController rangoFechaController = TextEditingController();
  DateTime? fechaInicio;
  DateTime? fechaTermino;
  RxBool isExpanded = true.obs;
  var entrenamientosResultado = [].obs;

  var rowsPerPage = 10.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalRecords = 0.obs;

  void clearFields() {

  }
}