import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/config/api/api.archivo.dart';
import 'package:sgem/config/api/api.modulo.maestro.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/config/api/api.entrenamiento.dart';
import 'package:sgem/config/constants/origen.archivo.dart';
import 'package:sgem/config/constants/tipo.archivo.modulo.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import 'package:sgem/shared/modules/modulo.maestro.dart';
import 'package:sgem/shared/modules/option.value.dart';
import '../../../../../../shared/widgets/alert/widget.alert.dart';
import '../../../../../../shared/widgets/dropDown/generic.dropdown.controller.dart';
import '../../entrenamiento.personal.controller.dart';

class EntrenamientoModuloNuevoController extends GetxController {
  TextEditingController fechaInicioController = TextEditingController();
  TextEditingController fechaTerminoController = TextEditingController();
  TextEditingController notaTeoricaController =
      TextEditingController(text: '0');
  TextEditingController notaPracticaController =
      TextEditingController(text: '0');
  TextEditingController fechaExamenController = TextEditingController();

  // Cambiado a Rx
  Rx<TextEditingController> totalHorasModuloController =
      TextEditingController(text: '0').obs;

  TextEditingController horasAcumuladasController =
      TextEditingController(text: '0');
  TextEditingController horasMinestarController =
      TextEditingController(text: '0');

  DateTime? fechaInicio;
  DateTime? fechaTermino = null;
  DateTime? fechaExamen;

  ArchivoService archivoService = ArchivoService();
  ModuloMaestroService moduloMaestroService = ModuloMaestroService();
  PersonalService personalService = PersonalService();
  EntrenamientoService entrenamientoService = EntrenamientoService();

  List<String> errores = [];

  TextEditingController aaControlHorasController = TextEditingController();
  TextEditingController aaExamenTeoricoController = TextEditingController();
  TextEditingController aaExamenPracticoController = TextEditingController();
  TextEditingController aaOtrosController = TextEditingController();

  var aaControlHorasSeleccionado = false.obs;
  var aaExamenTeoricoSeleccionado = false.obs;
  var aaExamenPracticoSeleccionado = false.obs;
  var aaOtrosSeleccionado = false.obs;

  Uint8List? aaControlHorasFileBytes;
  Uint8List? aaExamenTeoricoFileBytes;
  Uint8List? aaExamenPracticoFileBytes;
  Uint8List? aaOtrosFileBytes;

  var aaControlHorasExiste = false.obs;
  var aaExamenTeoricoExiste = false.obs;
  var aaExamenPracticoExiste = false.obs;
  var aaOtrosExiste = false.obs;

  var aaControlHorasId = 0.obs;
  var aaExamenTeoricoId = 0.obs;
  var aaExamenPracticoId = 0.obs;
  var aaOtrosId = 0.obs;

  RxBool isSaving = false.obs;

  EntrenamientoModulo? entrenamiento;
  int entrenamientoId = 0;
  int entrenamientoModuloId = 0;
  int? siguienteModulo;
  bool isEdit = false;
  bool isView = false;
  RxString tituloModal = ''.obs;
  RxInt inModulo = 1.obs;
  RxBool isLoadingModulo = false.obs;

  EntrenamientoModulo? entrenamientoModulo;

  final GenericDropdownController dropdownController =
      Get.find<GenericDropdownController>();

  Future<void> obtenerDatosModuloMaestro(int moduloNumero) async {
    log('Maestro: $moduloNumero');
    try {
      final response =
          await moduloMaestroService.obtenerModuloMaestroPorId(moduloNumero);
      if (response.success && response.data != null) {
        ModuloMaestro moduloMaestro = response.data!;
        log('horas: ${moduloMaestro.inHoras}');
        totalHorasModuloController.value.text =
            moduloMaestro.inHoras.toString();
      } else {
        log('Error al obtener los datos del módulo maestro: ${response.message}');
      }
    } catch (e) {
      log('Error al obtener el módulo maestro: $e');
    }
  }

  Future<bool> registrarModulo(BuildContext context) async {
    // log('${dropdownController.getSelectedValue('estadoModulo')!}');
    EntrenamientoModulo modulo = EntrenamientoModulo(
      key: isEdit ? entrenamientoModuloId : 0,
      inTipoActividad: entrenamiento!.inTipoActividad,
      inActividadEntrenamiento: entrenamiento!.key,
      inPersona: entrenamiento!.inPersona,
      inEntrenador: dropdownController.getSelectedValue('entrenador')!.key,
      entrenador: entrenamiento!.entrenador,
      fechaInicio: fechaInicio,
      fechaTermino: fechaTermino,
      fechaExamen: fechaExamen,
      inNotaTeorica: int.parse(notaTeoricaController.text),
      inNotaPractica: int.parse(notaPracticaController.text),
      inTotalHoras: int.parse(totalHorasModuloController.value.text),
      inHorasAcumuladas: int.parse(horasAcumuladasController.text),
      inHorasMinestar: int.parse(horasMinestarController.text),
      inModulo: inModulo.value,
      modulo: OptionValue(key: inModulo.value, nombre: ''),
      eliminado: 'N',
      motivoEliminado: '',
      tipoPersona: entrenamiento!.tipoPersona,
      inCategoria: entrenamiento!.inCategoria,
      inEquipo: entrenamiento!.inEquipo,
      equipo: entrenamiento!.equipo,
      inEmpresaCapacitadora: entrenamiento!.inEmpresaCapacitadora,
      inCondicion: entrenamiento!.inCondicion,
      condicion: entrenamiento!.condicion,
      inEstado: isEdit == true
          ? dropdownController.getSelectedValue('estadoModulo')!.key
          : 0,
      estadoEntrenamiento: OptionValue(key: 0, nombre: 'Pendiente'),
      comentarios: '',
      inCapacitacion: 0,
      observaciones: entrenamiento!.observaciones,
    );

    if (!isEdit) {
      if (!validar(context, modulo)) {
        _mostrarErroresValidacion(context, errores);
        return false;
      }
    }

    try {
      final response = isEdit
          ? await moduloMaestroService.actualizarModulo(modulo)
          : await moduloMaestroService.registrarModulo(modulo);
      if (response.success && response.data != null) {
        EntrenamientoPersonalController controller =
            Get.put(EntrenamientoPersonalController());
        controller
            .fetchModulosPorEntrenamiento(modulo.inActividadEntrenamiento!);
        controller.fetchTrainings(modulo.inPersona!);

        return true;
      } else {
        log('Error al ${isEdit ? "actualizar" : "registrar"} módulo: ${response.message}');

        return false;
      }
    } catch (e) {
      return false;
    }
  }

  bool validar(BuildContext context, EntrenamientoModulo modulo) {
    bool respuesta = true;
    errores.clear();

    if (dropdownController.getSelectedValue('entrenador') == null) {
      respuesta = false;
      errores.add("Debe seleccionar un entrenador responsable.");
    }

    if (modulo.inModulo == 1) {
      if (modulo.fechaInicio == null ||
          modulo.fechaInicio!.isBefore(modulo.fechaInicio!)) {
        respuesta = false;
        errores.add(
            "La fecha de inicio del Módulo I no puede ser anterior a la fecha de inicio del entrenamiento.");
      }
    }
    log("Modulo: $modulo");
    log("Modulo: ${modulo.inModulo!}");
    /*
    if (modulo.inModulo! >= 1) {
      if (modulo.fechaInicio == null ||
          modulo.fechaInicio!.isBefore(modulo.fechaTermino!)) {
        respuesta = false;
        errores.add(
            "La fecha de inicio del módulo no puede ser igual o antes a la fecha de término del módulo anterior.");
      }
    }
*/
    log('Fecha termino: ${modulo.fechaTermino}');
    if (modulo.fechaTermino != null) {
      if (modulo.fechaTermino!.isBefore(modulo.fechaInicio!)) {
        respuesta = false;
        errores.add(
            "La fecha de término no puede ser anterior a la fecha de inicio.");
      }
    }

    if (notaTeoricaController.text.isEmpty) {
      respuesta = false;
      errores.add("Debe ingresar una nota teórica.");
    } else {
      int? notaTeorica = int.tryParse(notaTeoricaController.text);
      if (notaTeorica == null || notaTeorica < 0) {
        respuesta = false;
        errores.add("La nota teórica debe ser un número mayor o igual a 0.");
      }
    }

    if (notaPracticaController.text.isEmpty) {
      respuesta = false;
      errores.add("Debe ingresar una nota práctica.");
    } else {
      int? notaPractica = int.tryParse(notaPracticaController.text);
      if (notaPractica == null || notaPractica < 0) {
        respuesta = false;
        errores.add("La nota práctica debe ser un número mayor o igual a 0.");
      }
    }

    if (fechaExamenController.text.isEmpty) {
      respuesta = false;
      errores.add("Debe seleccionar una fecha de examen.");
    } else {
      if (fechaExamen == null || fechaExamen!.isBefore(fechaInicio!)) {
        respuesta = false;
        errores.add(
            "La fecha del examen no puede ser anterior a la fecha de inicio del módulo.");
      }
    }
    log('Validar: ${respuesta}');
    return respuesta;
  }

  void _mostrarErroresValidacion(BuildContext context, List<String> errores) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MensajeValidacionWidget(errores: errores);
      },
    );
  }

  Future<void> nuevoModulo(int inEntrenamiento) async {
    tituloModal.value = 'Nuevo Modulo';

    var response =
        await entrenamientoService.obtenerEntrenamientoPorId(inEntrenamiento);

    if (response.success) {
      log('Obteniendo entrenamiento por id: $inEntrenamiento');
      entrenamiento = response.data;
      log('Entrenamiento: ${entrenamiento!.condicion!.nombre!}');
    }
    // Experiencia
    if (entrenamiento?.condicion?.nombre!.toLowerCase() == "experiencia") {
      var responseModulo = await entrenamientoService
          .obtenerUltimoModuloPorEntrenamiento(inEntrenamiento);

      if (responseModulo.success) {
        log('Obteniendo Ultimo modulo por entrenamiento: $inEntrenamiento');
        var ultimoModulo = responseModulo.data;

        log('Ultimo modulo: $ultimoModulo');
        if (ultimoModulo!.inModulo == null) {
          obtenerDatosModuloMaestro(1);
          tituloModal.value = 'Nuevo Modulo - Modulo I';
          inModulo.value = 1;
        }
        if (ultimoModulo.inModulo == 1) {
          obtenerDatosModuloMaestro(4);
          tituloModal.value = 'Nuevo Modulo - Modulo IV';
          inModulo.value = 4;
        }
      }
    } //Condicion: Entrenamiento (Sin Experiencia)

    else if (entrenamiento!.condicion?.nombre!.toLowerCase() ==
        "entrenamiento (sin experiencia)") {
      var responseModulo = await entrenamientoService
          .obtenerUltimoModuloPorEntrenamiento(inEntrenamiento);
      if (responseModulo.success) {
        log('Obteniendo Ultimo modulo por entrenamiento: $inEntrenamiento');
        var ultimoModulo = responseModulo.data;
        log('Ultimo modulo: ${ultimoModulo == null ? 'NUll' : ultimoModulo.key}');
        if (ultimoModulo!.inModulo == null) {
          obtenerDatosModuloMaestro(1);
          tituloModal.value = 'Nuevo Modulo - Modulo I';
          inModulo.value = 1;
        }
        if (ultimoModulo.inModulo == 1) {
          obtenerDatosModuloMaestro(2);
          tituloModal.value = 'Nuevo Modulo - Modulo II';
          inModulo.value = 2;
        }
        if (ultimoModulo.inModulo == 2) {
          obtenerDatosModuloMaestro(3);
          tituloModal.value = 'Nuevo Modulo - Modulo III';
          inModulo.value = 3;
        }
        if (ultimoModulo.inModulo == 3) {
          obtenerDatosModuloMaestro(4);
          tituloModal.value = 'Nuevo Modulo - Modulo IV';
          inModulo.value = 4;
        }
      }
    }
  }

  Future<void> obtenerModuloPorId(
      int inEntrenamiento, int inEntrenamientoModulo) async {
    var responseEntrenamiento =
        await entrenamientoService.obtenerEntrenamientoPorId(inEntrenamiento);

    if (responseEntrenamiento.success) {
      log('Obteniendo entrenamiento por id: $inEntrenamiento');
      entrenamiento = responseEntrenamiento.data;
      entrenamientoId = inEntrenamiento;
      entrenamientoModuloId = inEntrenamientoModulo;
      log('Entrenamiento: ${entrenamiento!.condicion!.nombre!}');
    }

    try {
      log('Obteniendo modulo por id: $inEntrenamientoModulo');
      final response =
          await moduloMaestroService.obtenerModuloPorId(inEntrenamientoModulo);

      log('Obteniendo modulo por id: ${response.success}');
      if (response.success) {
        log('Modulo obtenido: ${response.data}');
        entrenamientoModulo = response.data!;
        await obtenerDatosModuloMaestro(entrenamientoModulo!.inModulo!);
        await llenarDatos();
      } else {
        Get.snackbar('Error', 'No se pudieron cargar el módulo');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un problema al cargar el módulo');
    }
  }

  String formatoFechaPantalla(DateTime? fecha) {
    return fecha != null ? DateFormat('dd/MM/yyyy').format(fecha) : '';
  }

  Future<void> llenarDatos() async {
    fechaInicio = entrenamientoModulo!.fechaInicio;
    fechaInicioController.text = formatoFechaPantalla(fechaInicio);
    fechaTermino = entrenamientoModulo!.fechaTermino;
    fechaTerminoController.text = formatoFechaPantalla(fechaTermino);
    notaTeoricaController.text = entrenamientoModulo!.inNotaTeorica.toString();
    notaPracticaController.text =
        entrenamientoModulo!.inNotaPractica.toString();
    fechaExamen = entrenamientoModulo!.fechaExamen;
    fechaExamenController.text = formatoFechaPantalla(fechaExamen!);
    totalHorasModuloController.value.text =
        entrenamientoModulo!.inTotalHoras.toString();
    horasAcumuladasController.text =
        entrenamientoModulo!.inHorasAcumuladas.toString();
    horasMinestarController.text =
        entrenamientoModulo!.inHorasMinestar.toString();
    tituloModal.value = isView
        ? 'Ver Módulo - ${entrenamientoModulo!.modulo!.nombre!}'
        : 'Editar Módulo - ${entrenamientoModulo!.modulo!.nombre!}';
    dropdownController.selectValueKey(
        'entrenador', entrenamientoModulo!.inEntrenador);
    dropdownController.selectValueKey(
        'estadoModulo', entrenamientoModulo!.inEstado);

    inModulo.value = entrenamientoModulo!.inModulo!;

    await obtenerArchivosRegistrados();
  }

  Future<void> cargarArchivoControlHoras() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['*.*'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        if (file.bytes != null) {
          //Uint8List fileBytes = file.bytes!;
          aaControlHorasFileBytes = file.bytes!;
          String fileName = file.name;

          aaControlHorasController.text =
              fileName; // Muestra el nombre del archivo
          log('Documento adjuntado correctamente: $fileName');

          aaControlHorasSeleccionado.value = true;
        }
      } else {
        log('No se seleccionaron archivos');
      }
    } catch (e) {
      log('Error al adjuntar documentos: $e');
    }
  }

  Future<void> cargarArchivoExamenTeorico() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['*.*'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        if (file.bytes != null) {
          //Uint8List fileBytes = file.bytes!;
          aaExamenTeoricoFileBytes = file.bytes!;
          String fileName = file.name;

          aaExamenTeoricoController.text =
              fileName; // Muestra el nombre del archivo
          log('Documento adjuntado correctamente: $fileName');

          aaExamenTeoricoSeleccionado.value = true;
        }
      } else {
        log('No se seleccionaron archivos');
      }
    } catch (e) {
      log('Error al adjuntar documentos: $e');
    }
  }

  Future<String> cargarArchivoExamenPractico() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        if (file.bytes != null) {
          //Uint8List fileBytes = file.bytes!;
          aaExamenPracticoFileBytes = file.bytes!;
          String fileName = file.name;

          aaExamenPracticoController.text =
              fileName; // Muestra el nombre del archivo
          log('Documento adjuntado correctamente: $fileName');
          aaExamenPracticoSeleccionado.value = true;
          return 'Control de horas adjuntado correctamente: $fileName';
        }
      } else {
        return 'No se seleccionaron archivos';
      }
    } catch (e) {
      return 'Error al adjuntar documentos: $e';
    }
    return '';
  }

  Future<void> cargarArchivoOtros() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['*.*'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        if (file.bytes != null) {
          //Uint8List fileBytes = file.bytes!;
          aaOtrosFileBytes = file.bytes!;
          String fileName = file.name;

          aaOtrosController.text = fileName; // Muestra el nombre del archivo
          log('Documento adjuntado correctamente: $fileName');

          aaOtrosSeleccionado.value = true;
        }
      } else {
        log('No se seleccionaron archivos');
      }
    } catch (e) {
      log('Error al adjuntar documentos: $e');
    }
  }

  Future<String> registrarArchivoControlHoras() async {
    try {
      String datosBase64 = base64Encode(aaControlHorasFileBytes!);
      String extension = aaControlHorasController.text.split('.').last;
      String mimeType = _determinarMimeType(extension);

      final response = await archivoService.registrarArchivo(
        key: 0,
        nombre: aaControlHorasController.text,
        extension: extension,
        mime: mimeType,
        datos: datosBase64,
        inTipoArchivo: TipoArchivoModulo.CONTROL_HORAS,
        inOrigen: OrigenArchivo.entrenamientoModulo,
        inOrigenKey: entrenamientoModuloId,
      );

      if (response.success) {
        aaControlHorasSeleccionado.value = false;
        obtenerArchivosRegistrados();
        // Get.snackbar(
        //   'Exito',
        //   'Archivo subido exitosamente: ${response.message}',
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
        log('Archivo ${aaControlHorasController.text} registrado con éxito');
        return 'Archivo ${aaControlHorasController.text} registrado con éxito';
      } else {
        log('Error al registrar archivo  ${aaControlHorasController.text}: ${response.message}');
        return 'Error al registrar archivo  ${aaControlHorasController.text}: ${response.message}';
      }
    } catch (e) {
      log('Error al registrar archivos: $e');
      return 'Error al registrar archivos: $e';
    }
  }

  Future<void> registrarArchivoExamenTeorico() async {
    try {
      String datosBase64 = base64Encode(aaExamenTeoricoFileBytes!);
      String extension = aaExamenTeoricoController.text.split('.').last;
      String mimeType = _determinarMimeType(extension);

      final response = await archivoService.registrarArchivo(
        key: 0,
        nombre: aaExamenTeoricoController.text,
        extension: extension,
        mime: mimeType,
        datos: datosBase64,
        inTipoArchivo: TipoArchivoModulo.EXAMEN_TEORICO,
        inOrigen: OrigenArchivo.entrenamientoModulo,
        inOrigenKey: entrenamientoModuloId,
      );

      if (response.success) {
        aaExamenTeoricoSeleccionado.value = false;
        obtenerArchivosRegistrados();
        // Get.snackbar(
        //   'Exito',
        //   'Archivo subido exitosamente: ${response.message}',
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
        log('Archivo ${aaExamenTeoricoController.text} registrado con éxito');
      } else {
        log('Error al registrar archivo  ${aaExamenTeoricoController.text}: ${response.message}');
      }
    } catch (e) {
      log('Error al registrar archivos: $e');
    }
  }

  Future<void> registrarArchivoExamenPractico() async {
    try {
      String datosBase64 = base64Encode(aaExamenPracticoFileBytes!);
      String extension = aaExamenPracticoController.text.split('.').last;
      String mimeType = _determinarMimeType(extension);

      final response = await archivoService.registrarArchivo(
        key: 0,
        nombre: aaExamenPracticoController.text,
        extension: extension,
        mime: mimeType,
        datos: datosBase64,
        inTipoArchivo: TipoArchivoModulo.EXAMEN_PRACTICO,
        inOrigen: OrigenArchivo.entrenamientoModulo,
        inOrigenKey: entrenamientoModuloId,
      );

      if (response.success) {
        aaExamenPracticoSeleccionado.value = false;
        obtenerArchivosRegistrados();
        // Get.snackbar(
        //   'Exito',
        //   'Archivo subido exitosamente: ${response.message}',
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
        log('Archivo ${aaExamenPracticoController.text} registrado con éxito');
      } else {
        log('Error al registrar archivo  ${aaExamenPracticoController.text}: ${response.message}');
      }
    } catch (e) {
      log('Error al registrar archivos: $e');
    }
  }

  Future<void> registrarArchivoOtros() async {
    try {
      String datosBase64 = base64Encode(aaOtrosFileBytes!);
      String extension = aaOtrosController.text.split('.').last;
      String mimeType = _determinarMimeType(extension);

      final response = await archivoService.registrarArchivo(
        key: 0,
        nombre: aaOtrosController.text,
        extension: extension,
        mime: mimeType,
        datos: datosBase64,
        inTipoArchivo: TipoArchivoModulo.OTROS,
        inOrigen: OrigenArchivo.entrenamientoModulo,
        inOrigenKey: entrenamientoModuloId,
      );

      if (response.success) {
        aaOtrosSeleccionado.value = false;
        obtenerArchivosRegistrados();
        // Get.snackbar(
        //   'Exito',
        //   'Archivo subido exitosamente: ${response.message}',
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
        log('Archivo ${aaOtrosController.text} registrado con éxito');
      } else {
        log('Error al registrar archivo  ${aaOtrosController.text}: ${response.message}');
      }
    } catch (e) {
      log('Error al registrar archivos: $e');
    }
  }

  String _determinarMimeType(String extension) {
    switch (extension.toLowerCase()) {
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

  Future<void> obtenerArchivosRegistrados() async {
    try {
      final response = await archivoService.obtenerArchivosPorOrigen(
        idOrigen: OrigenArchivo.entrenamientoModulo,
        idOrigenKey: entrenamientoModuloId,
      );

      log('Response: ${response.data}');
      if (response.success && response.data != null) {
        aaControlHorasController.clear();
        aaExamenTeoricoController.clear();
        aaExamenPracticoController.clear();
        aaOtrosController.clear();

        aaControlHorasExiste.value = false;
        aaExamenTeoricoExiste.value = false;
        aaExamenPracticoExiste.value = false;
        aaOtrosExiste.value = false;

        for (var archivo in response.data!) {
          log('Tipo Archivo Modulo: ${archivo['InTipoArchivo']}');
          List<int> datos = List<int>.from(archivo['Datos']);
          Uint8List archivoBytes = Uint8List.fromList(datos);
          if (archivo['InTipoArchivo'] == TipoArchivoModulo.CONTROL_HORAS) {
            aaControlHorasController.text = archivo['Nombre'];
            aaControlHorasExiste.value = true;
            aaControlHorasId.value = archivo['Key'];
          }
          if (archivo['InTipoArchivo'] == TipoArchivoModulo.EXAMEN_TEORICO) {
            aaExamenTeoricoController.text = archivo['Nombre'];
            aaExamenTeoricoExiste.value = true;
            aaExamenTeoricoId.value = archivo['Key'];
          }
          if (archivo['InTipoArchivo'] == TipoArchivoModulo.EXAMEN_PRACTICO) {
            aaExamenPracticoController.text = archivo['Nombre'];
            aaExamenPracticoExiste.value = true;
            aaExamenPracticoId.value = archivo['Key'];
          }
          if (archivo['InTipoArchivo'] == TipoArchivoModulo.OTROS) {
            aaOtrosController.text = archivo['Nombre'];
            aaOtrosExiste.value = true;
            aaOtrosId.value = archivo['Key'];
          }
          log('Archivo ${archivo['Nombre']} obtenido con éxito');
        }
      } else {
        log('Error al obtener archivos: ${response.message}');
      }
    } catch (e) {
      log('Error al obtener archivos: $e');
    }
  }

  bool validarArchivosPorSubir() {
    if (aaControlHorasSeleccionado.value ||
        aaExamenTeoricoSeleccionado.value ||
        aaExamenPracticoSeleccionado.value ||
        aaOtrosSeleccionado.value) {
      log('Control de horas existe ${aaControlHorasSeleccionado.value}');
      log('Examen Teorico existe ${aaExamenTeoricoSeleccionado.value}');
      log('Examen Practico existe ${aaExamenPracticoSeleccionado.value}');
      log('Otros existe ${aaOtrosSeleccionado.value}');

      return true;
    }
    return false;
  }

  bool validarArchivosObligatorios() {
    if (aaControlHorasExiste.value &&
        aaExamenTeoricoExiste.value &&
        aaExamenPracticoExiste.value) {
      return true;
    }
    return false;
  }

  Future<void> subirArchivos() async {
    if (aaControlHorasSeleccionado.value) {
      await registrarArchivoControlHoras();
    }
    if (aaExamenTeoricoSeleccionado.value) {
      await registrarArchivoExamenTeorico();
    }
    if (aaExamenPracticoSeleccionado.value) {
      await registrarArchivoExamenPractico();
    }
    if (aaOtrosSeleccionado.value) {
      await registrarArchivoOtros();
    }
  }

  Future<void> eliminarArchivo(int archivoId) async {
    try {
      log('Archivo Id: ${archivoId}');
      final response = await archivoService.eliminarArchivo(
        key: archivoId,
        nombre: '',
        extension: '',
        mime: '',
        datos: '',
        inTipoArchivo: 0,
        inOrigen: 0,
        inOrigenKey: 0,
      );
      log('Response: ${response}');
      if (response.success) {
        Get.snackbar(
          'Exito',
          'Archivo eliminado exitosamente: ${response.message}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        obtenerArchivosRegistrados();
      } else {
        Get.snackbar(
          'Error',
          'No se pudo eliminar el archivo: ${response.message}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        obtenerArchivosRegistrados();
      }
    } catch (e) {
      log('Error al eliminar el archivo: $e');
      Get.snackbar(
        'Error',
        'No se pudo eliminar el archivo: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
