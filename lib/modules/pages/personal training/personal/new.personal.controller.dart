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
  var selectedPersonal = Rxn<Personal>();

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
        await loadPersonalPhoto(personalData!.inPersonalOrigen);
        llenarControladores(personalData!);
      } else {
        log('Error al buscar el personal: ${response.message}');
      }
    } catch (e) {
      log('Error inesperado al buscar el personal: $e');
    }
  }

  Future<void> buscarPersonalPorId(String id) async {
    try {
      final personalJson = await personalService.buscarPersonalPorId(id);
      personalData = Personal.fromJson(personalJson);

      llenarControladores(personalData);
    } catch (e) {
      log('Error al buscar el personal: $e');
    }
  }

  DateTime? parseDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) {
      return null;
    }
    try {
      return DateTime.parse(rawDate);
    } catch (e) {
      log('Error al parsear la fecha: $e');
      return null;
    }
  }

  void llenarControladores(Personal? personal) {
    if (personal != null) {
      dniController.text = personal.numeroDocumento;
      nombresController.text =
          '${personal.primerNombre} ${personal.segundoNombre}';
      puestoTrabajoController.text = personal.cargo;
      codigoController.text = personal.codigoMcp;
      apellidoPaternoController.text = personal.apellidoPaterno;
      apellidoMaternoController.text = personal.apellidoMaterno;
      gerenciaController.text = personal.gerencia;

      fechaIngresoController.text = personal.fechaIngreso != null
          ? formatDate(personal.fechaIngreso!)
          : '';

      fechaIngresoMinaController.text = personal.fechaIngresoMina != null
          ? formatDate(personal.fechaIngresoMina!)
          : '';

      fechaRevalidacionController.text = personal.licenciaVencimiento != null
          ? formatDate(personal.licenciaVencimiento!)
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
    }
  }

  Future<bool> gestionarPersona({
    required String accion,
    String? motivoEliminacion,
    required BuildContext context,
  }) async {
    log('Gestionando persona con la acción: $accion');
/*
    if (!validate(context)) {
      log('Datos incompletos');
      return false;
    }
*/
    try {
      String _obtenerPrimerNombre(String nombres) {
        List<String> nombresSplit = nombres.split(' ');
        return nombresSplit.isNotEmpty ? nombresSplit.first : '';
      }

      String _obtenerSegundoNombre(String nombres) {
        List<String> nombresSplit = nombres.split(' ');
        return nombresSplit.length > 1 ? nombresSplit[1] : '';
      }

      String _verificarTexto(String texto) {
        return texto.isNotEmpty ? texto : '';
      }

      DateTime? _parsearFecha(String fechaTexto) {
        return fechaTexto.isNotEmpty
            ? DateFormat('yyyy-MM-dd').parse(fechaTexto)
            : null;
      }

      personalData!
        ..primerNombre = _obtenerPrimerNombre(nombresController.text)
        ..segundoNombre = _obtenerSegundoNombre(nombresController.text)
        ..apellidoPaterno = _verificarTexto(apellidoPaternoController.text)
        ..apellidoMaterno = _verificarTexto(apellidoMaternoController.text)
        ..cargo = _verificarTexto(puestoTrabajoController.text)
        ..fechaIngreso = _parsearFecha(fechaIngresoController.text)
        ..fechaIngresoMina = _parsearFecha(fechaIngresoMinaController.text)
        ..licenciaVencimiento = _parsearFecha(fechaRevalidacionController.text)
        ..operacionMina = isOperacionMina.value ? 'S' : 'N'
        ..zonaPlataforma = isZonaPlataforma.value ? 'S' : 'N'
        ..restricciones = _verificarTexto(restriccionesController.text);

      if (accion == 'eliminar') {
        personalData!
          ..eliminado = 'S'
          ..motivoElimina = motivoEliminacion ?? 'Sin motivo'
          ..usuarioElimina = 'usuarioActual';
      }

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

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  //Validaciones
  bool validate(BuildContext context) {
    /*
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
    }*/
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
