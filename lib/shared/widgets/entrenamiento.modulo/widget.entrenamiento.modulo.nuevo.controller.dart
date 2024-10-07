import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EntrenamientoModuloNuevoController extends GetxController {
  TextEditingController fechaInicioController = TextEditingController();
  TextEditingController fechaTerminoController = TextEditingController();
  TextEditingController responsableController = TextEditingController();
  TextEditingController notaTeoricaController = TextEditingController();
  TextEditingController notaPracticaController = TextEditingController();
  TextEditingController fechaExamenController = TextEditingController();
  TextEditingController totalHorasModuloController = TextEditingController();
  TextEditingController horasAcumuladasController = TextEditingController();
  TextEditingController horasMinestarController = TextEditingController();

  RxBool isSaving = false.obs;

  void resetControllers(){

  }
}
