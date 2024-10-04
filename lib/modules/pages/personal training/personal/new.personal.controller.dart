import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/config/api/archivo.dart';
import 'package:sgem/config/api/response.handler.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:file_picker/file_picker.dart';

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
  var selectedGuardiaKey = RxnInt();

  Personal? personalData;
  Rxn<Uint8List?> personalPhoto = Rxn<Uint8List?>();
  var estadoPersonal = 'Cesado'.obs;

  RxBool isOperacionMina = false.obs;
  RxBool isZonaPlataforma = false.obs;

  var documentoAdjuntoNombre = ''.obs;
  var documentoAdjuntoBytes = Rxn<Uint8List>();
  final ArchivoService archivoService = ArchivoService();

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
      loadPersonalPhoto(personal.inPersonalOrigen);
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
      if (personal.guardia.key != 0) {
        selectedGuardiaKey.value = personal.guardia.key;
      } else {
        selectedGuardiaKey.value = null;
      }
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
        ..guardia.key = selectedGuardiaKey.value ?? 0
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
        await registrarArchivo();
        return personalService.registrarPersona(personalData!);
      case 'actualizar':
        log('Actualizar');
        await registrarArchivo();
        return personalService.actualizarPersona(personalData!);
      case 'eliminar':
        log('Eliminar');
        return personalService.eliminarPersona(personalData!);
      default:
        throw Exception('Acción no reconocida: $accion');
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
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

  void adjuntarDocumento() async {
    try {
      final resultado = await seleccionarArchivo();

      if (resultado != null) {
        documentoAdjuntoNombre.value = resultado['nombre'];
        documentoAdjuntoBytes.value = resultado['bytes'];
        log('Documento adjuntado correctamente: ${documentoAdjuntoNombre.value}');
      } else {
        log('No se seleccionó ningún archivo');
      }
    } catch (e) {
      log('Error al adjuntar documento: $e');
    }
  }

  Future<Map<String, dynamic>?> seleccionarArchivo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xlsx'],
      );

      if (result != null && result.files.single.bytes != null) {
        Uint8List fileBytes = result.files.single.bytes!;
        String fileName = result.files.single.name;
        return {
          'nombre': fileName,
          'bytes': fileBytes,
        };
      }
    } catch (e) {
      log('Error al seleccionar el archivo: $e');
      return null;
    }
    return null;
  }

  void eliminarDocumento() {
    documentoAdjuntoNombre.value = '';
    documentoAdjuntoBytes.value = null;
    log('Documento eliminado');
  }

  Future<void> registrarArchivo() async {
    if (documentoAdjuntoBytes.value != null &&
        documentoAdjuntoNombre.value.isNotEmpty) {
      try {
        String datosBase64 = base64Encode(documentoAdjuntoBytes.value!);

        String extension = documentoAdjuntoNombre.value.split('.').last;
        String mimeType = _determinarMimeType(extension);

        final response = await archivoService.registrarArchivo(
          key: 0,
          nombre: documentoAdjuntoNombre.value,
          extension: extension,
          mime: mimeType,
          datos: datosBase64,
          inTipoArchivo: 1,
          inOrigen: 1,
        );

        if (response.success) {
          log('Archivo registrado con éxito');
        } else {
          log('Error al registrar el archivo: ${response.message}');
        }
      } catch (e) {
        log('Error inesperado al registrar archivo: $e');
      }
    } else {
      log('No hay archivo adjunto para registrar');
    }
  }

  String _determinarMimeType(String extension) {
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      default:
        return 'application/octet-stream';
    }
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
    categoriaLicenciaController.clear();
    codigoLicenciaController.clear();
    fechaIngresoMinaController.clear();
    fechaRevalidacionController.clear();
    restriccionesController.clear();
    selectedGuardiaKey.value = null;
    personalPhoto.value = null;
    isOperacionMina.value = false;
    isZonaPlataforma.value = false;
    estadoPersonal.value = 'Activo';
    documentoAdjuntoNombre.value = '';
    documentoAdjuntoBytes.value = null;
    personalData = null;
  }
}
