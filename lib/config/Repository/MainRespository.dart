import 'dart:developer';
import 'package:sgem/config/api/api.maestro.detail.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';

class MainRepository {
  final personalService = PersonalService();
  final maestroDetalleService = MaestroDetalleService();

  Future<List<MaestroDetalle>?> listarMaestroDetallePorMaestro(int key) async {
    try {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(key);
      if (response.success) {
        return response.data;
      } else {
        log('Error: ${response.message}');
        return null;
      }
    } catch (e) {
      log('Error cargando la data de guardia maestro: $e');
      return null;
    }
  }
}
