import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController restriccionesController = TextEditingController();

  final PersonalService personalService = PersonalService();
  Personal? personalData;
  Rxn<Uint8List?> personalPhoto = Rxn<Uint8List?>();
  var estadoPersonal = 'Cesado'.obs;

  RxBool isOperacionMina = false.obs;
  RxBool isZonaPlataforma = false.obs;

  Future<void> loadPersonalPhoto(int idOrigen) async {
    try {
      final photoResponse =
          await personalService.obtenerFotoPorCodigoOrigen(idOrigen);
      log(photoResponse.data.toString());

      if (photoResponse.success && photoResponse.data != null) {
        personalPhoto.value = photoResponse.data;
        log('Foto del personal cargada con éxito');
      } else {
        log('Error al cargar la foto: ${photoResponse.message}');
      }
    } catch (e) {
      log('Error al cargar la foto del personal: $e');
    }
  }

  Future<void> buscarPersonalPorDni(String dni) async {
    try {
      final response = await personalService.buscarPersonalPorDni(dni);

      if (response.success && response.data != null) {
        personalData = response.data;
        log('Personal encontrado: ${personalData!.toJson().toString()}');
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

    isOperacionMina.value = personal.operacionMina == 'S';
    isZonaPlataforma.value = personal.zonaPlataforma == 'S';

    if (personal.estado.nombre == 'Activo') {
      estadoPersonal.value = 'Activo';
    } else {
      estadoPersonal.value = 'Cesado';
    }
    log('Controladores llenados con éxito');
    log('Estado del personal: ${estadoPersonal.value}');
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
      log('Intentando gestionar persona...');
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
            ? DateFormat('dd/MM/yyyy').parse(fechaIngresoController.text)
            : null
        ..fechaIngresoMina = fechaIngresoMinaController.text.isNotEmpty
            ? DateFormat('dd/MM/yyyy').parse(fechaIngresoMinaController.text)
            : null
        ..licenciaConducir = codigoLicenciaController.text.isNotEmpty
            ? codigoLicenciaController.text
            : ''
        ..licenciaVencimiento = fechaRevalidacionController.text.isNotEmpty
            ? DateFormat('dd/MM/yyyy').parse(fechaRevalidacionController.text)
            : null

        ..operacionMina = isOperacionMina.value ? 'S' : 'N'
        ..zonaPlataforma = isZonaPlataforma.value ? 'S' : 'N'
        ..restricciones = restriccionesController.text.isNotEmpty
            ? restriccionesController.text
            : '';

      if (accion == 'eliminar') {
        log('Preparando datos para eliminar');
        personalData!
          ..eliminado = 'S'
          ..motivoElimina = motivoEliminacion ?? 'Sin motivo'
          ..usuarioElimina = 'usuarioActual';
      }

      log('Datos de la persona antes de eliminar: ${personalData!.toJson()}');

      final response = await _accionPersona(accion);

      if (response.success) {
        log('Acción $accion realizada exitosamente');
        return true;
      } else {
        log('Acción $accion fallida: ${response.message}');
        return false;
      }
    } catch (e) {
      log('Error al $accion persona: $e');
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
        log('Actualizar');
        return personalService.actualizarPersona(personalData!);
      case 'eliminar':
        log('Eliminar');
        return personalService.eliminarPersona(personalData!);
      default:
        throw Exception('Acción no reconocida: $accion');
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  //Validaciones
  bool validate(BuildContext context) {
    if (dniController.text.isEmpty || dniController.text.length != 8) {
      return false;
    }
    if (nombresController.text.isEmpty) {
      return false;
    }
    if (apellidoPaternoController.text.isEmpty) {
      return false;
    }
    if (apellidoMaternoController.text.isEmpty) {
      return false;
    }
    if (codigoLicenciaController.text.isEmpty) {
      return false;
    }
    return true;
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
    restriccionesController.clear();
  }
}
