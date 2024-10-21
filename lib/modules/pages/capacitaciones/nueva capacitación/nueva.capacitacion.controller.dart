import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.archivo.dart';

class NuevaCapacitacionController extends GetxController {
  final TextEditingController codigoMcpController = TextEditingController();
  final TextEditingController horasController = TextEditingController();
  final TextEditingController entrenadorController = TextEditingController();
  final TextEditingController fechaInicioController = TextEditingController();
  final TextEditingController fechaTerminoController = TextEditingController();
  final TextEditingController nombreCapacitacionController =
      TextEditingController();
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController guardiaController = TextEditingController();

  RxnString tipoSeleccionado = RxnString();
  RxnString categoriaSeleccionada = RxnString();
  RxnString empresaSeleccionada = RxnString();

  RxList<String> categoriaOpciones =
      <String>['Seguridad', 'Salud', 'Tecnología'].obs;
  RxList<String> empresaOpciones =
      <String>['Empresa A', 'Empresa B', 'Empresa C'].obs;

  var archivosAdjuntos = <Map<String, dynamic>>[].obs;

  final ArchivoService archivoService = ArchivoService();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> adjuntarDocumento() async {
    try {
      var archivo = {
        'nombre': 'Documento Ejemplo.pdf',
        'bytes': [/* datos del archivo */]
      };
      archivosAdjuntos.add(archivo);
    } catch (e) {
      mostrarMensaje('Error', 'No se pudo adjuntar el documento');
    }
  }

  void eliminarArchivo(Map<String, dynamic> archivo) {
    archivosAdjuntos.remove(archivo);
  }

  void mostrarMensaje(String titulo, String mensaje) {
    // Implementar lógica para mostrar mensaje
  }

  Future<void> guardarCapacitacion() async {
    if (_validarFormulario()) {
      mostrarMensaje('Éxito', 'La capacitación ha sido guardada correctamente');
    } else {
      mostrarMensaje('Error', 'Por favor completa todos los campos requeridos');
    }
  }

  bool _validarFormulario() {
    if (codigoMcpController.text.isEmpty ||
        horasController.text.isEmpty ||
        tipoSeleccionado.value == null ||
        categoriaSeleccionada.value == null ||
        empresaSeleccionada.value == null) {
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    codigoMcpController.dispose();
    horasController.dispose();
    entrenadorController.dispose();
    fechaInicioController.dispose();
    fechaTerminoController.dispose();
    nombreCapacitacionController.dispose();
    codigoController.dispose();
    nombresController.dispose();
    guardiaController.dispose();
    super.onClose();
  }
}
