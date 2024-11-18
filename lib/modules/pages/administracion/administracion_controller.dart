import 'package:get/get.dart';
import 'package:sgem/modules/pages/administracion/administracion.dart';

class AdministracionController extends GetxController {
  Rx<AdministracionScreen> screenPage = AdministracionScreen.none.obs;

  void changePage(AdministracionScreen page) {
    if (screenPage.value == page) {
      return;
    }

    screenPage.value = page;
  }

  void screenPop() {
    screenPage.value = AdministracionScreen.none;
  }
}
