import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

  RxBool isSaving = false.obs;

  EntrenamientoModulo? entrenamiento;
  int? siguienteModulo;
  bool isEdit = false;
  RxString tituloModal = ''.obs;
  RxInt inModulo = 1.obs;
  RxBool isLoadingModulo = false.obs;

  //int? inEntrenamiento;

  EntrenamientoModulo? entrenamientoModulo;

  final GenericDropdownController dropdownController =
      Get.find<GenericDropdownController>();

/*
  Future<void> setDatosEntrenamiento(
      EntrenamientoModulo entrenamiento, bool isEdit) async {
    //this.entrenamiento = entrenamiento;
    this.isEdit = isEdit;

    if (entrenamiento.fechaInicio != null) {
      fechaInicio = entrenamiento.fechaInicio;
      fechaInicioController.text =
          DateFormat('dd/MM/yyyy').format(entrenamiento.fechaInicio!);
    }

    if (entrenamiento.fechaTermino != null) {
      fechaTermino = entrenamiento.fechaTermino;
      fechaTerminoController.text =
          DateFormat('dd/MM/yyyy').format(entrenamiento.fechaTermino!);
    }

    if (!isEdit) {
      await obtenerSiguienteModulo();

      if (siguienteModulo == null) {
        return;
      }

      int moduloNumero = siguienteModulo ?? 1;
      //tituloModal = 'Nuevo Módulo - Módulo ${convertirARomano(moduloNumero)}';
      //tituloModal = 'Nuevo Módulo - ${}';
      // await obtenerDatosModuloMaestro(moduloNumero);
    } else {
      int moduloNumero = entrenamiento.inModulo ?? 1;
      //tituloModal = 'Editar Módulo - Módulo ${convertirARomano(moduloNumero)}';
      // await obtenerDatosModuloMaestro(moduloNumero);
    }
    update();
  }

  Future<void> obtenerSiguienteModulo() async {
    isLoadingModulo.value = true;
    try {
      final modulos = await entrenamientoService
          .obtenerUltimoModuloPorEntrenamiento(entrenamiento!.key!);
      if (modulos.success && modulos.data != null) {
        int ultimosModulos = modulos.data!.inModulo!;

        int maxModulosPermitidos =
            entrenamiento!.condicion!.nombre! == "Experiencia" ? 2 : 4;

        if (ultimosModulos >= maxModulosPermitidos) {
          siguienteModulo = null;
        } else {
          siguienteModulo = ultimosModulos + 1;
        }
      } else {
        siguienteModulo = 1;
      }
    } catch (e) {
      siguienteModulo = 1;
      log('Error obteniendo el siguiente módulo: $e');
    } finally {
      isLoadingModulo.value = false;
      update();
    }
  }
*/
  Future<void> obtenerDatosModuloMaestro(int moduloNumero) async {
    try {
      final response =
          await moduloMaestroService.obtenerModuloMaestroPorId(moduloNumero);
      if (response.success && response.data != null) {
        ModuloMaestro moduloMaestro = response.data!;
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
    if (!validar(context)) {
      _mostrarErroresValidacion(context, errores);
      return false;
    }

    // int moduloNumero = isEdit ? entrenamiento!.inModulo! : siguienteModulo!;

    EntrenamientoModulo modulo = EntrenamientoModulo(
      key: isEdit ? entrenamiento!.key : 0,
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
      inEstado: 0,
      estadoEntrenamiento: OptionValue(key: 0, nombre: 'Pendiente'),
      comentarios: '',
      inCapacitacion: 0,
      observaciones: entrenamiento!.observaciones,
    );

    try {
      final response = isEdit
          ? await moduloMaestroService.actualizarModulo(modulo)
          : await moduloMaestroService.registrarModulo(modulo);
      if (response.success && response.data != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Módulo ${isEdit ? "actualizado" : "registrado"} con éxito."),
            backgroundColor: Colors.green,
          ),
        );

        EntrenamientoPersonalController controller =
            Get.find<EntrenamientoPersonalController>();
        controller.fetchModulosPorEntrenamiento(entrenamiento!.key!);

        return true;
      } else {
        log('Error al ${isEdit ? "actualizar" : "registrar"} módulo: ${response.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Error al ${isEdit ? "actualizar" : "registrar"} módulo: ${response.message}"),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Error al ${isEdit ? "actualizar" : "registrar"} módulo: $e"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  bool validar(BuildContext context) {
    bool respuesta = true;
    errores.clear();

    if (dropdownController.getSelectedValue('entrenador') == null) {
      respuesta = false;
      errores.add("Debe seleccionar un entrenador responsable.");
    }

    if (entrenamiento?.inModulo == 1) {
      if (fechaInicio == null ||
          fechaInicio!.isBefore(entrenamiento!.fechaInicio!)) {
        respuesta = false;
        errores.add(
            "La fecha de inicio del Módulo I no puede ser anterior a la fecha de inicio del entrenamiento.");
      }
    }

    if (entrenamiento!.inModulo! > 1) {
      if (fechaInicio == null ||
          fechaInicio!.isBefore(entrenamiento!.fechaTermino!)) {
        respuesta = false;
        errores.add(
            "La fecha de inicio del módulo no puede ser igual o antes a la fecha de término del módulo anterior.");
      }
    }

    if (fechaTermino == null || fechaTermino!.isBefore(fechaInicio!)) {
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
    //EntrenamientoModulo? entrenamiento2 = EntrenamientoModulo();
    //TODO: Obtener el Entrenamiento
    var response =
        await entrenamientoService.obtenerEntrenamientoPorId(inEntrenamiento);

    if (response.success) {
      log('Obteniendo entrenamiento por id: $inEntrenamiento');
      entrenamiento = response.data;
      log('Entrenamiento: ${entrenamiento!.condicion!.nombre!}');
    }
    // Experiencia
    // Entrenamiento (Sin experiencia)
    if (entrenamiento?.condicion?.nombre!.toLowerCase() == "experiencia") {
      var responseModulo = await entrenamientoService
          .obtenerUltimoModuloPorEntrenamiento(inEntrenamiento);
      if (responseModulo.success) {
        log('Obteniendo Ultimo modulo por entrenamiento: $inEntrenamiento');
        var ultimoModulo = responseModulo.data;
        log('Ultimo modulo: $ultimoModulo');
      }
    } else if (entrenamiento!.condicion?.nombre!.toLowerCase() ==
        "entrenamiento (sin experiencia)") {
      var responseModulo = await entrenamientoService
          .obtenerUltimoModuloPorEntrenamiento(inEntrenamiento);
      if (responseModulo.success) {
        log('Obteniendo Ultimo modulo por entrenamiento: $inEntrenamiento');
        var ultimoModulo = responseModulo.data;
        log('Ultimo modulo: ${ultimoModulo == null ? 'NUll' : ultimoModulo.key}');
        if (ultimoModulo!.key == null) {
          tituloModal.value = 'Nuevo Modulo - Modulo I';
          inModulo.value = 1;
        }
      }
    }

    //TODO : Obtener la condicion del entrenamiento (Experiencia / sin experiencia)

    //TODO: Validar el modulo que corresponde; I y IV / I, II, II , IV
  }

  Future<void> obtenerModuloPorId(int inEntrenamientoModulo) async {
    try {
      log('Obteniendo modulo por id: $inEntrenamientoModulo');
      final response =
          await moduloMaestroService.obtenerModuloPorId(inEntrenamientoModulo);
      log('Obteniendo modulo por id: ${response.success}');
      if (response.success) {
        log('Modulo obtenido: ${response.data}');
        entrenamientoModulo = response.data!;
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
  }
}
