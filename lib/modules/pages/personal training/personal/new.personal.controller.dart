import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/shared/modules/personal.dart';

class NewPersonalController extends GetxController {
  final TextEditingController dniController = TextEditingController();
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController puestoTrabajoController = TextEditingController();
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController apellidoPaternoController =
      TextEditingController();
  final TextEditingController apellidoMaternoController =
      TextEditingController();
  final TextEditingController gerenciaController = TextEditingController();
  final TextEditingController fechaIngresoController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController categoriaLicenciaController =
      TextEditingController();
  final TextEditingController codigoLicenciaController =
      TextEditingController();
  final TextEditingController fechaIngresoMinaController =
      TextEditingController();
  final TextEditingController fechaRevalidacionController =
      TextEditingController();
  final TextEditingController operacionMinaController = TextEditingController();
  final TextEditingController zonaPlataformaController =
      TextEditingController();
  final TextEditingController restriccionesController = TextEditingController();

  final PersonalService personalService = PersonalService();
  Personal? personalData;

  Future<void> buscarPersonalPorDni(String dni) async {
    try {
      final response = await personalService.buscarPersonalPorDni(dni);

      if (response.success && response.data != null) {
        personalData = response.data;
        llenarControladores(personalData!);
      } else {
        log('Error al buscar el personal: ${response.message}');
      }
    } catch (e) {
      log('Error inesperado al buscar el personal: $e');
    }
  }

  DateTime? parseDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(rawDate); // Handle ISO 8601 formatted dates
    } catch (e) {
      log('Error al parsear la fecha: $e');
      return null;
    }
  }

  void llenarControladores(Personal personal) {
    dniController.text = personal.numeroDocumento;
    nombresController.text =
        '${personal.primerNombre} ${personal.segundoNombre}';
    puestoTrabajoController.text = personal.cargo;
    codigoController.text = personal.codigoMcp;
    apellidoPaternoController.text = personal.apellidoPaterno;
    apellidoMaternoController.text = personal.apellidoMaterno;
    gerenciaController.text = personal.gerencia;

    fechaIngresoController.text = personal.fechaIngreso != null
        ? _formatDate(parseDate(personal.fechaIngreso.toString())!)
        : '';

    fechaIngresoMinaController.text = personal.fechaIngresoMina != null
        ? _formatDate(personal.fechaIngresoMina!)
        : '';

    fechaRevalidacionController.text = personal.licenciaVencimiento != null
        ? _formatDate(personal.licenciaVencimiento!)
        : '';

    areaController.text = personal.area;
    categoriaLicenciaController.text = personal.licenciaCategoria;
    codigoLicenciaController.text = personal.licenciaConducir;
    restriccionesController.text = personal.restricciones;
    operacionMinaController.text = personal.operacionMina;
    zonaPlataformaController.text = personal.zonaPlataforma;
  }

  Future<bool> gestionarPersona({
    required String accion,
    String? motivoEliminacion,
    required BuildContext context,
  }) async {
    if (!validate(context)) {
      return false;
    }

    try {
      personalData!
        ..primerNombre = nombresController.text.split(' ').first
        ..segundoNombre = nombresController.text.split(' ').length > 1
            ? nombresController.text.split(' ')[1]
            : ''
        ..apellidoPaterno = apellidoPaternoController.text.isNotEmpty
            ? apellidoPaternoController.text
            : ''
        ..apellidoMaterno = apellidoMaternoController.text.isNotEmpty
            ? apellidoMaternoController.text
            : ''
        ..cargo = puestoTrabajoController.text.isNotEmpty
            ? puestoTrabajoController.text
            : ''
        ..codigoMcp =
            codigoController.text.isNotEmpty ? codigoController.text : ''
        ..gerencia =
            gerenciaController.text.isNotEmpty ? gerenciaController.text : ''
        ..area = areaController.text.isNotEmpty ? areaController.text : ''
        ..fechaIngreso = fechaIngresoController.text.isNotEmpty
            ? DateTime.parse(fechaIngresoController.text)
            : null
        ..fechaIngresoMina = fechaIngresoMinaController.text.isNotEmpty
            ? DateTime.parse(fechaIngresoMinaController.text)
            : null
        ..licenciaConducir = codigoLicenciaController.text.isNotEmpty
            ? codigoLicenciaController.text
            : ''
        ..licenciaVencimiento = fechaRevalidacionController.text.isNotEmpty
            ? DateTime.parse(fechaRevalidacionController.text)
            : null
        ..operacionMina = operacionMinaController.text.isNotEmpty
            ? operacionMinaController.text
            : ''
        ..zonaPlataforma = zonaPlataformaController.text.isNotEmpty
            ? zonaPlataformaController.text
            : ''
        ..restricciones = restriccionesController.text.isNotEmpty
            ? restriccionesController.text
            : '';

      if (accion == 'eliminar') {
        personalData!
          ..eliminado = 'S'
          ..motivoElimina = motivoEliminacion ?? 'Sin motivo'
          ..usuarioElimina = 'usuarioActual';
      }

      final response = await _accionPersona(accion);

      if (response.success) {
        log('Acción $accion realizada exitosamente');
        // Redirigir a la página de "Buscar Entrenamiento" en caso de éxito
        Get.toNamed('/buscarEntrenamiento');
        return true;
      } else {
        log('Acción $accion fallida: ${response.message}');
        showErrorModal(
            context, response.message ?? 'Error al gestionar la persona');
        return false;
      }
    } catch (e) {
      log('Error al $accion persona: $e');
      showErrorModal(context, 'Error al $accion persona');
      return false;
    }
  }

  Future<ResponseHandler<bool>> _accionPersona(String accion) async {
    log('Personal: ${personalData.toString()}');
    switch (accion) {
      case 'registrar':
        log('Registrar');
        return personalService.registrarPersona(personalData!);
      case 'actualizar':
        return personalService.actualizarPersona(personalData!);
      case 'eliminar':
        return personalService.eliminarPersona(personalData!);
      default:
        throw Exception('Acción no reconocida: $accion');
    }
  }

  String _formatDate(DateTime date) {
    return date.toIso8601String(); // ISO 8601 format
  }
  //Validaciones
  bool validate(BuildContext context) {
    if (dniController.text.isEmpty || dniController.text.length != 8) {
      showErrorModal(
          context, 'El campo DNI es obligatorio y debe contener 8 dígitos.');
      return false;
    }
    if (nombresController.text.isEmpty) {
      showErrorModal(context, 'El campo Nombres es obligatorio.');
      return false;
    }
    if (apellidoPaternoController.text.isEmpty) {
      showErrorModal(context, 'El campo Apellido Paterno es obligatorio.');
      return false;
    }
    if (apellidoMaternoController.text.isEmpty) {
      showErrorModal(context, 'El campo Apellido Materno es obligatorio.');
      return false;
    }
    if (codigoLicenciaController.text.isEmpty) {
      showErrorModal(context, 'El campo Código Licencia es obligatorio.');
      return false;
    }
    /*
    if (fechaIngresoMinaController.text.isNotEmpty &&
        DateTime.parse(fechaIngresoMinaController.text)
            .isBefore(DateTime.parse(fechaIngresoController.text)))
    {
      showErrorModal(context,
          'La fecha de ingreso a mina no puede ser anterior a la fecha de ingreso a la empresa.');
      return false;
    }
    */
    return true;
  }

  // Restaurar el diseño original del modal
  void showErrorModal(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: MediaQuery.of(context).size.width * 0.2,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void resetControllers() {
    dniController.clear();
    nombresController.clear();
    puestoTrabajoController.clear();
    codigoController.clear();
    apellidoPaternoController.clear();
    apellidoMaternoController.clear();
    gerenciaController.clear();
    fechaIngresoController.clear();
    areaController.clear();
    codigoLicenciaController.clear();
    fechaIngresoMinaController.clear();
    fechaRevalidacionController.clear();
    operacionMinaController.clear();
    zonaPlataformaController.clear();
    restriccionesController.clear();
  }
}
