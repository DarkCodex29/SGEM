
import 'dart:developer';

import 'package:sgem/config/api/api.maestro.detail.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';

class MainRepository {

  final personalService = PersonalService();
  final maestroDetalleService = MaestroDetalleService();

  Future<void> listarMaestroDetallePorMaestro(int key, Function(List<MaestroDetalle>?) success) async {
    try {
      var response = await maestroDetalleService.listarMaestroDetallePorMaestro(key);
      if (response.success) {
        success(response.data);
      } else {
        log('Error: ${response.message}');
      }
    } catch (e) {
      log('Error cargando la data de guardia maestro: $e');
    }
  }
}