import 'dart:developer';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/config/api/api.modulo.maestro.dart';
import 'package:sgem/config/api/api.training.dart';
import 'package:sgem/shared/modules/entrenamiento.consulta.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/modules/modulo.maestro.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';

import '../../../config/api/api.maestro.detail.dart';

class TrainingsController extends GetxController {
  TextEditingController codigoMcpController = TextEditingController();
  TextEditingController rangoFechaController = TextEditingController();
  TextEditingController nombresController = TextEditingController();

  DateTime? fechaInicio;
  DateTime? fechaTermino;

  final entrenamientoService = TrainingService();
  final maestroDetalleService = MaestroDetalleService();
  final moduloService = ModuloMaestroService();
  RxBool isExpanded = true.obs;
  var entrenamientoResultados = <EntrenamientoConsulta>[].obs;

  var selectedEquipoKey = RxnInt();
  var selectedModuloKey = RxnInt();
  var selectedGuardiaKey = RxnInt();
  var selectedEstadoEntrenamientoKey = RxnInt();
  var selectedCondicionKey = RxnInt();

  RxList<ModuloMaestro> moduloOpciones = <ModuloMaestro>[].obs;
  RxList<MaestroDetalle> guardiaOpciones = <MaestroDetalle>[].obs;
  RxList<MaestroDetalle> equipoOpciones = <MaestroDetalle>[].obs;
  RxList<MaestroDetalle> estadoEntrenamientoOpciones = <MaestroDetalle>[].obs;
  RxList<MaestroDetalle> condicionOpciones = <MaestroDetalle>[].obs;

  var rowsPerPage = 10.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalRecords = 0.obs;

  final GenericDropdownController<MaestroDetalle> dropdownController =
      Get.put(GenericDropdownController<MaestroDetalle>());
  final GenericDropdownController<ModuloMaestro> moduloDropdownController =
      Get.put(GenericDropdownController<ModuloMaestro>());

  @override
  void onInit() {
    /*
    cargarModulo();
    cargarEquipo();
    cargarGuardia();
    cargarEstadoEntrenamiento();
    cargarCondicion();
    */
    buscarEntrenamientos(
        pageNumber: currentPage.value, pageSize: rowsPerPage.value);
    super.onInit();
  }

  void cargarDropdowns() {
    dropdownController.loadOptions('equipo', () async {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(5);
      return response.success && response.data != null
          ? response.data!
          : <MaestroDetalle>[];
    });

    dropdownController.loadOptions('guardia', () async {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(2);
      return response.success && response.data != null
          ? response.data!
          : <MaestroDetalle>[];
    });

    dropdownController.loadOptions('estadoEntrenamiento', () async {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(4);
      return response.success && response.data != null
          ? response.data!
          : <MaestroDetalle>[];
    });

    dropdownController.loadOptions('condicion', () async {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(3);
      return response.success && response.data != null
          ? response.data!
          : <MaestroDetalle>[];
    });

    moduloDropdownController.loadOptions('modulo', () async {
      var response = await moduloService.listarMaestros();
      return response.success && response.data != null
          ? response.data!
          : <ModuloMaestro>[];
    });
  }

  Future<void> buscarEntrenamientos(
      {int pageNumber = 1, int pageSize = 10}) async {
    String? codigoMcp =
        codigoMcpController.text.isEmpty ? null : codigoMcpController.text;
    String? nombres =
        nombresController.text.isEmpty ? null : nombresController.text;
    try {
      var response = await entrenamientoService.consultarEntrenamientoPaginado(
        codigoMcp: codigoMcp,
        inEquipo: selectedEquipoKey.value,
        inModulo: selectedModuloKey.value,
        inGuardia: selectedGuardiaKey.value,
        inEstadoEntrenamiento: selectedEstadoEntrenamientoKey.value,
        inCondicion: selectedCondicionKey.value,
        fechaInicio: fechaInicio,
        fechaTermino: fechaTermino,
        nombres: nombres,
        pageSize: pageSize,
        pageNumber: pageNumber,
      );

      if (response.success && response.data != null) {
        try {
          var result = response.data as Map<String, dynamic>;
          log('Respuesta recibida correctamente $result');

          var items = result['Items'] as List<EntrenamientoConsulta>;
          log('Items obtenidos: $items');

          entrenamientoResultados.assignAll(items);

          currentPage.value = result['PageNumber'] as int;
          totalPages.value = result['TotalPages'] as int;
          totalRecords.value = result['TotalRecords'] as int;
          rowsPerPage.value = result['PageSize'] as int;
          isExpanded.value = false;

          log('Resultados obtenidos: ${entrenamientoResultados.length}');
        } catch (e) {
          log('Error al procesar la respuesta: $e');
        }
      } else {
        log('Error en la búsqueda: ${response.message}');
      }
    } catch (e) {
      log('Error en la búsqueda 2: $e');
    }
  }

  Future<void> downloadExcel() async {
    var excel = Excel.createExcel();
    excel.rename('Sheet1', 'Entrenamiento');

    CellStyle headerStyle = CellStyle(
      backgroundColorHex: ExcelColor.blue,
      fontColorHex: ExcelColor.white,
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );
    List<String> headers = [
      'CODIGO_MCP',
      'NOMBRES Y APELLIDOS',
      'GUARDIA',
      'ESTADO_ENTRENAMIENTO',
      'ESTADO_AVANCE',
      ' CONDICIÓN',
      ' EQUIPO',
      'FECHA_INICIO',
      'FECHA_FIN',
      'ENTRENADOR_RESPONSABLE',
      'NOTA_TEÓRICA',
      'NOTA_PRÁCTICA',
      'HORAS_ACUMULADAS'
    ];

    for (int i = 0; i < headers.length; i++) {
      var cell = excel.sheets['Entrenamiento']!
          .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;

      excel.sheets['Entrenamiento']!
          .setColumnWidth(i, headers[i].length.toDouble() + 5);
    }

    final dateFormat = DateFormat('dd/MM/yyyy');

    for (int rowIndex = 0;
        rowIndex < entrenamientoResultados.length;
        rowIndex++) {
      var entrenamiento = entrenamientoResultados[rowIndex];
      List<CellValue> row = [
        TextCellValue(entrenamiento.codigoMcp),
        TextCellValue(entrenamiento.nombreCompleto),
        TextCellValue(entrenamiento.guardia.nombre!),
        TextCellValue(entrenamiento.estadoEntrenamiento.nombre!),
        TextCellValue(entrenamiento.modulo.nombre!),
        TextCellValue(entrenamiento.condicion.nombre!),
        TextCellValue(entrenamiento.equipo.nombre!),
        entrenamiento.fechaInicio != null
            ? TextCellValue(dateFormat.format(entrenamiento.fechaInicio!))
            : TextCellValue(''),
        entrenamiento.fechaTermino != null
            ? TextCellValue(dateFormat.format(entrenamiento.fechaTermino!))
            : TextCellValue(''),
        TextCellValue(entrenamiento.entrenador.nombre!),
        TextCellValue(entrenamiento.notaTeorica.toString()),
        TextCellValue(entrenamiento.notaPractica.toString()),
        TextCellValue(entrenamiento.horasAcumuladas.toString()),
      ];

      for (int colIndex = 0; colIndex < row.length; colIndex++) {
        var cell = excel.sheets['Entrenamiento']!.cell(
            CellIndex.indexByColumnRow(
                columnIndex: colIndex, rowIndex: rowIndex + 1));
        cell.value = row[colIndex];

        double contentWidth = row[colIndex].toString().length.toDouble();
        if (contentWidth >
            excel.sheets['Entrenamiento']!.getColumnWidth(colIndex)) {
          excel.sheets['Entrenamiento']!
              .setColumnWidth(colIndex, contentWidth + 5);
        }
      }
    }

    var excelBytes = excel.encode();
    Uint8List uint8ListBytes = Uint8List.fromList(excelBytes!);

    String fileName = generateExcelFileName();
    await FileSaver.instance.saveFile(
        name: fileName,
        bytes: uint8ListBytes,
        ext: "xlsx",
        mimeType: MimeType.microsoftExcel);
  }

  String generateExcelFileName() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year.toString().substring(2);
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');

    return 'ENTRENAMIENTOS_MINA_$day$month$year$hour$minute$second.xlsx';
  }

  Future<void> cargarEquipo() async {
    try {
      var response = await maestroDetalleService
          .listarMaestroDetallePorMaestro(5); //Maestro de Equipos

      if (response.success && response.data != null) {
        equipoOpciones.assignAll(response.data!);

        log('Equipos opciones cargadas correctamente: $equipoOpciones');
      } else {
        log('Error: ${response.message}');
      }
    } catch (e) {
      log('Error cargando la data de guardia maestro: $e');
    }
  }

  Future<void> cargarGuardia() async {
    try {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(2);

      if (response.success && response.data != null) {
        guardiaOpciones.assignAll(response.data!);

        log('Guardia opciones cargadas correctamente: $guardiaOpciones');
      } else {
        log('Error: ${response.message}');
      }
    } catch (e) {
      log('Error cargando la data de guardia maestro: $e');
    }
  }

  Future<void> cargarEstadoEntrenamiento() async {
    try {
      var response = await maestroDetalleService.listarMaestroDetallePorMaestro(
          4); //Catalogo de Estado de Entrenamiento

      if (response.success && response.data != null) {
        estadoEntrenamientoOpciones.assignAll(response.data!);

        log('Estado entrenamiento opciones cargadas correctamente: $estadoEntrenamientoOpciones');
      } else {
        log('Error: ${response.message}');
      }
    } catch (e) {
      log('Error cargando la data de estado entrenamiento maestro: $e');
    }
  }

  Future<void> cargarCondicion() async {
    try {
      var response = await maestroDetalleService.listarMaestroDetallePorMaestro(
          3); //Catalogo de condicion de entrenamiento

      if (response.success && response.data != null) {
        condicionOpciones.assignAll(response.data!);

        log('Condicion de entrenamiento opciones cargadas correctamente: $estadoEntrenamientoOpciones');
      } else {
        log('Error: ${response.message}');
      }
    } catch (e) {
      log('Error cargando la data de condicion de entrenamiento maestro: $e');
    }
  }

  Future<void> cargarModulo() async {
    try {
      var response = await moduloService.listarMaestros();

      if (response.success && response.data != null) {
        moduloOpciones.assignAll(response.data!);

        log('Modulos maestro opciones cargadas correctamente: $guardiaOpciones');
      } else {
        log('Error: ${response.message}');
      }
    } catch (e) {
      log('Error cargando la data de Modulos maestro: $e');
    }
  }

  void clearFields() {
    codigoMcpController.clear();
    selectedEquipoKey.value = null;
    selectedModuloKey.value = null;
    selectedGuardiaKey.value = null;
    selectedEstadoEntrenamientoKey.value = null;
    selectedCondicionKey.value = null;
    rangoFechaController.clear();
    fechaInicio = null;
    fechaTermino = null;
    nombresController.clear();
  }
}
