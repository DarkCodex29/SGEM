import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.modulo.maestro.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/config/api/api.training.dart';
import 'package:sgem/modules/pages/personal.training/training/training.personal.controller.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import 'package:sgem/shared/modules/personal.dart';
import '../../../../../../shared/widgets/alert/widget.alert.dart';

class EntrenamientoModuloNuevoController extends GetxController {
  TextEditingController fechaInicioController = TextEditingController();
  TextEditingController fechaTerminoController = TextEditingController();
  TextEditingController responsableController = TextEditingController();
  TextEditingController notaTeoricaController =
      TextEditingController(text: '0');
  TextEditingController notaPracticaController =
      TextEditingController(text: '0');
  TextEditingController fechaExamenController = TextEditingController();
  TextEditingController totalHorasModuloController =
      TextEditingController(text: '0');
  TextEditingController horasAcumuladasController =
      TextEditingController(text: '0');
  TextEditingController horasMinestarController =
      TextEditingController(text: '0');

  DateTime? fechaInicio;
  DateTime? fechaTermino;
  DateTime? fechaExamen;

  ModuloMaestroService moduloMaestroService = ModuloMaestroService();
  PersonalService personalService = PersonalService();
  TrainingService trainingService = TrainingService();

  List<String> errores = [];

  RxBool isSaving = false.obs;
  RxBool isLoadingResponsable = false.obs;
  RxList<Personal> responsables = <Personal>[].obs;
  Personal? responsableSeleccionado;

  late EntrenamientoModulo entrenamiento;

  void buscarEntrenadores(String query) async {
    if (query.isEmpty) {
      responsables.clear();
      return;
    }
    isLoadingResponsable.value = true;
    final result = await personalService.listarEntrenadores();
    if (result.success) {
      responsables.value = result.data!
          .where((entrenador) =>
              entrenador.nombreCompleto
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              entrenador.apellidoPaterno
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    }
    isLoadingResponsable.value = false;
  }

  void seleccionarEntrenador(Personal responsable) {
    responsableSeleccionado = responsable;
    responsableController.text = responsable.nombreCompleto;
  }

  void setDatosEntrenamiento(EntrenamientoModulo entrenamiento) {
    this.entrenamiento = entrenamiento;

    if (entrenamiento.fechaInicio != null) {
      fechaInicio = entrenamiento.fechaInicio;
      fechaInicioController.text = entrenamiento.fechaInicio.toString();
    }

    if (entrenamiento.fechaTermino != null) {
      fechaTermino = entrenamiento.fechaTermino;
      fechaTerminoController.text = entrenamiento.fechaTermino.toString();
    }
  }

  void resetControllers() {
    fechaInicioController.clear();
    fechaTerminoController.clear();
    responsableController.clear();
    notaTeoricaController.clear();
    notaPracticaController.clear();
    fechaExamenController.clear();
    totalHorasModuloController.clear();
    horasAcumuladasController.clear();
    horasMinestarController.clear();

    errores.clear();

    isSaving.value = false;
    isLoadingResponsable.value = false;
  }

  bool validar(BuildContext context) {
    bool respuesta = true;
    errores.clear();

    // Validación del entrenador
    if (responsableController.text.isEmpty) {
      respuesta = false;
      errores.add("Debe seleccionar un entrenador responsable.");
    }

    // Validación de la fecha de inicio del Módulo I
    if (entrenamiento.inModulo == 1) {
      if (fechaInicio == null ||
          fechaInicio!.isBefore(entrenamiento.fechaInicio!)) {
        respuesta = false;
        errores.add(
            "La fecha de inicio del Módulo I no puede ser anterior a la fecha de inicio del entrenamiento.");
      }
    }

    // Validación de la fecha de inicio del módulo que no sea I
    if (entrenamiento.inModulo > 1) {
      if (fechaInicio == null ||
          fechaInicio!.isBefore(entrenamiento.fechaTermino!)) {
        respuesta = false;
        errores.add(
            "La fecha de inicio del módulo no puede ser igual o antes a la fecha de término del módulo anterior.");
      }
    }

    // Validación de la fecha de término
    if (fechaTermino == null || fechaTermino!.isBefore(fechaInicio!)) {
      respuesta = false;
      errores.add(
          "La fecha de término no puede ser anterior a la fecha de inicio.");
    }

    // Validación de la nota teórica
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

    // Validación de la nota práctica
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

    // Validación de la fecha de examen
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

  Future<int> obtenerSiguienteModulo() async {
    try {
      final modulos = await trainingService
          .obtenerUltimoModuloPorEntrenamiento(entrenamiento.key);
      log('Modulos: ${modulos.data}');
      if (modulos.success && modulos.data != null) {
        int ultimosModulos = modulos.data!.inModulo;
        return ultimosModulos + 1;
      } else {
        log('Error obteniendo el siguiente módulo: ${modulos.message}');
        return 1;
      }
    } catch (e) {
      log('Error obteniendo el siguiente módulo: $e');
      return 1;
    }
  }

  Future<bool> registrarModulo(BuildContext context) async {
    if (!validar(context)) {
      _mostrarErroresValidacion(context, errores);
      return false;
    }
    int siguienteModulo = await obtenerSiguienteModulo();

    EntrenamientoModulo modulo = EntrenamientoModulo(
      key: 0,
      inTipoActividad: entrenamiento.inTipoActividad,
      inActividadEntrenamiento: entrenamiento.key,
      inPersona: entrenamiento.inPersona,
      inEntrenador: responsableSeleccionado!.inPersonalOrigen,
      entrenador: entrenamiento.entrenador,
      fechaInicio: fechaInicio,
      fechaTermino: fechaTermino,
      fechaExamen: fechaExamen,
      inNotaTeorica: int.parse(notaTeoricaController.text),
      inNotaPractica: int.parse(notaPracticaController.text),
      inTotalHoras: int.parse(totalHorasModuloController.text),
      inHorasAcumuladas: int.parse(horasAcumuladasController.text),
      inHorasMinestar: int.parse(horasMinestarController.text),
      inModulo: siguienteModulo,
      modulo: Entidad(key: siguienteModulo, nombre: 'Módulo $siguienteModulo'),
      eliminado: 'N',
      motivoEliminado: '',
      inTipoPersona: entrenamiento.inTipoPersona,
      inCategoria: entrenamiento.inCategoria,
      inEquipo: entrenamiento.inEquipo,
      equipo: entrenamiento.equipo,
      inEmpresaCapacitadora: entrenamiento.inEmpresaCapacitadora,
      inCondicion: entrenamiento.inCondicion,
      condicion: entrenamiento.condicion,
      inEstado: 0,
      estadoEntrenamiento: Entidad(key: 0, nombre: 'Pendiente'),
      comentarios: '',
      inCapacitacion: 0,
      observaciones: entrenamiento.observaciones,
    );

    try {
      final response = await moduloMaestroService.registrarModulo(modulo);
      if (response.success && response.data != null) {
        log('Registrar módulo exitoso: ${response.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Módulo registrado con éxito."),
            backgroundColor: Colors.green,
          ),
        );
        TrainingPersonalController controller =
            Get.find<TrainingPersonalController>();
        controller.fetchModulosPorEntrenamiento(entrenamiento.key);

        return true;
      } else {
        log('Error al registrar módulo: ${response.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al registrar módulo: ${response.message}"),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      log('CATCH: Error al registrar módulo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al registrar módulo: $e"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  void _mostrarErroresValidacion(BuildContext context, List<String> errores) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MensajeValidacionWidget(errores: errores);
      },
    );
  }
}
