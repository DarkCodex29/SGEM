import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart';
import 'package:sgem/config/api/api.modulo.maestro.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/config/api/api.entrenamiento.dart';
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
  DateTime? fechaTermino;
  DateTime? fechaExamen;

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
        /*
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(
                "Módulo ${isEdit ? "actualizado" : "registrado"} con éxito."),
            backgroundColor: Colors.green,
          ),
        );
*/
        EntrenamientoPersonalController controller =
            Get.put(EntrenamientoPersonalController());
        controller
            .fetchModulosPorEntrenamiento(modulo.inActividadEntrenamiento!);
        controller.fetchTrainings(modulo.inPersona!);

        return true;
      } else {
        log('Error al ${isEdit ? "actualizar" : "registrar"} módulo: ${response.message}');
        /*
        
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(
                "Error al ${isEdit ? "actualizar" : "registrar"} módulo: ${response.message}"),
            backgroundColor: Colors.red,
          ),
        );
        */
        return false;
      }
    } catch (e) {
      /*
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(
              "Error al ${isEdit ? "actualizar" : "registrar"} módulo: $e"),
          backgroundColor: Colors.red,
        ),
      );*/
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
    if (modulo.fechaTermino == null ||
        modulo.fechaTermino!.isBefore(modulo.fechaInicio!)) {
      respuesta = false;
      errores.add(
          "La fecha de término no puede ser anterior a la fecha de inicio.");
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
        obtenerDatosModuloMaestro(entrenamientoModulo!.inModulo!);
        llenarDatos();
      } else {
        Get.snackbar('Error', 'No se pudieron cargar el módulo');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un problema al cargar el módulo');
    }
  }

  void llenarDatos() {
    fechaInicio = entrenamientoModulo!.fechaInicio;
    fechaInicioController.text = DateFormat('dd/MM/yyyy').format(fechaInicio!);
    fechaTermino = entrenamientoModulo!.fechaTermino;
    fechaTerminoController.text =
        DateFormat('dd/MM/yyyy').format(fechaTermino!);
    notaTeoricaController.text = entrenamientoModulo!.inNotaTeorica.toString();
    notaPracticaController.text =
        entrenamientoModulo!.inNotaPractica.toString();
    fechaExamen = entrenamientoModulo!.fechaExamen;
    fechaExamenController.text = DateFormat('dd/MM/yyyy').format(fechaExamen!);
    totalHorasModuloController.value.text =
        entrenamientoModulo!.inTotalHoras.toString();
    horasAcumuladasController.text =
        entrenamientoModulo!.inHorasAcumuladas.toString();
    horasMinestarController.text =
        entrenamientoModulo!.inHorasMinestar.toString();
    tituloModal.value =
        'Editar Módulo - ${entrenamientoModulo!.modulo!.nombre!}';
    dropdownController.selectValueKey(
        'entrenador', entrenamientoModulo!.inEntrenador);
    inModulo.value = entrenamientoModulo!.inModulo!;
  }
}
