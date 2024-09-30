import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/shared/modules/personal.dart';

class NewPersonalController {
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
        ? _formatDate(personal.fechaIngreso!)
        : '';
    areaController.text = personal.area;
    codigoLicenciaController.text = personal.licenciaCategoria;
    restriccionesController.text = personal.restricciones;
    operacionMinaController.text = personal.operacionMina;
    zonaPlataformaController.text = personal.zonaPlataforma;
    fechaIngresoMinaController.text = personal.fechaIngresoMina != null
        ? _formatDate(personal.fechaIngresoMina!)
        : '';
    fechaRevalidacionController.text = personal.licenciaVencimiento != null
        ? _formatDate(personal.licenciaVencimiento!)
        : '';
  }

  Future<void> gestionarPersona({
    required String accion,
    String? motivoEliminacion,
  }) async {
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
      } else {
        log('Acción $accion fallida: ${response.message}');
      }
    } catch (e) {
      log('Error al $accion persona: $e');
    }
  }

  Future<ResponseHandler<bool>> _accionPersona(String accion) async {
    switch (accion) {
      case 'registrar':
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
    return '${date.day}/${date.month}/${date.year}';
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
