import 'package:get/get.dart';

import 'administracion.enum.dart';

class AdministracionController extends GetxController{
  var screenPage = AdministracionScreen.none.obs;


  void showMantenimientoMaestro() {
    screenPage.value = AdministracionScreen.maestro;
  }
}