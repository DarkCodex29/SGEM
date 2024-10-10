import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrainingsController extends GetxController{
  TextEditingController codigoMcpController = TextEditingController();
  TextEditingController rangoFechaController = TextEditingController();
  DateTime? fechaInicio;
  DateTime? fechaTermino;
  RxBool isExpanded = true.obs;

  void clearFields() {

  }
}