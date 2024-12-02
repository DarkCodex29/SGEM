import 'dart:developer';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:sgem/config/api/api.entrenamiento.dart';
import 'package:sgem/config/api/api.maestro.detail.dart';
import 'package:sgem/config/api/api.modulo.maestro.dart';
import 'package:sgem/config/api/api.monitoring.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/modules/modulo.maestro.dart';
import 'package:sgem/shared/modules/monitoring.dart';
import 'package:sgem/shared/modules/personal.dart';

enum MonitoringSearchScreen {
  none,
  newMonitoring,
  editMonitoring,
  trainingForm,
  viewMonitoring,
  carnetMonitoring,
  diplomaMonitoring,
  certificadoMonitoring,
  actualizacionMasiva
}

extension MonitoringSearchScreenExtension on MonitoringSearchScreen {
  String description() {
    switch (this) {
      case MonitoringSearchScreen.none:
        return "";
      case MonitoringSearchScreen.newMonitoring:
        return "Nuevo Monitoring a Entrenar";
      case MonitoringSearchScreen.editMonitoring:
        return "Editar Monitoring";
      case MonitoringSearchScreen.trainingForm:
        return "Búsqueda de entrenamiento de Monitoring";
      case MonitoringSearchScreen.viewMonitoring:
        return "Visualizar";
      case MonitoringSearchScreen.carnetMonitoring:
        return "Carnet del Monitoring";
      case MonitoringSearchScreen.actualizacionMasiva:
        return "Actualizacion Masiva";
      default:
        return "Entrenamientos";
    }
  }
}

class MonitoringSearchController extends GetxController {
  final PersonalService personalService = PersonalService();
  final entrenamientoService = EntrenamientoService();
  final maestroDetalleService = MaestroDetalleService();
  final moduloService = ModuloMaestroService();
  final monitoringService = MonitoringService();
  TextEditingController codigoMCPController = TextEditingController();
  TextEditingController documentoIdentidadController = TextEditingController();
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidosMaternoController = TextEditingController();
  TextEditingController apellidosPaternoController = TextEditingController();
  TextEditingController rangoFechaController = TextEditingController();

  DateTime? fechaInicio;
  DateTime? fechaTermino;
  var screen = MonitoringSearchScreen.none.obs;
  var isExpanded = true.obs;
  var rowsPerPage = 10.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalRecords = 0.obs;
  RxList<MaestroDetalle> guardiaOptions = <MaestroDetalle>[].obs;
  var monitoringAll = <Monitoring>[].obs;

  RxList<ModuloMaestro> moduloOpciones = <ModuloMaestro>[].obs;
  RxList<MaestroDetalle> guardiaOpciones = <MaestroDetalle>[].obs;
  RxList<MaestroDetalle> equipoOpciones = <MaestroDetalle>[].obs;
  RxList<MaestroDetalle> estadoEntrenamientoOpciones = <MaestroDetalle>[].obs;
  RxList<MaestroDetalle> condicionOpciones = <MaestroDetalle>[].obs;
  RxList<Personal> entrenadores = <Personal>[].obs;

  var selectedEquipoKey = RxnInt();
  var selectedEntrenadorKey = RxnInt();
  var selectedModuloKey = RxnInt();
  var selectedGuardiaKey = RxnInt();
  var selectedEstadoEntrenamientoKey = RxnInt();
  var selectedCondicionKey = RxnInt();

  @override
  void onInit() {
    cargarModulo();
    cargarEquipo();
    cargarGuardia();
    cargarEstadoEntrenamiento();
    cargarCondicion();
    cargarEntrenadores();
    searchMonitoring(
        pageNumber: currentPage.value, pageSize: rowsPerPage.value);
    super.onInit();
  }

  static Logger _logger = Logger('MonitoringSearchController');

  clearFilter() {
    codigoMCPController = TextEditingController(text: "");
    documentoIdentidadController = TextEditingController(text: "");
    nombresController = TextEditingController(text: "");
    apellidosMaternoController = TextEditingController(text: "");
    apellidosPaternoController = TextEditingController(text: "");
    rangoFechaController = TextEditingController(text: "");
    fechaInicio = null;
    fechaTermino = null;
    selectedEquipoKey.value = null;
    selectedEntrenadorKey.value = null;
    selectedModuloKey.value = null;
    selectedGuardiaKey.value = null;
    selectedEstadoEntrenamientoKey.value = null;
    selectedCondicionKey.value = null;
  }

  Future<void> searchMonitoring({int pageNumber = 1, int pageSize = 10}) async {
    String? codigoMcp =
        codigoMCPController.text.isEmpty ? null : codigoMCPController.text;
    String? apellidoMaterno = apellidosMaternoController.text.isEmpty
        ? null
        : apellidosMaternoController.text;
    String? apllidoPaterno = apellidosPaternoController.text.isEmpty
        ? null
        : apellidosPaternoController.text;
    String? nombres =
        nombresController.text.isEmpty ? null : nombresController.text;

    try {
      var response = await monitoringService.queryMonitoringPaginated(
          codigoMcp: codigoMcp,
          apellidoMaterno: apellidoMaterno,
          apellidoPaterno: apllidoPaterno,
          nombres: nombres,
          inEntrenador: selectedEntrenadorKey.value,
          inCondicion: selectedCondicionKey.value,
          inEquipo: selectedEquipoKey.value,
          inEstadoEntrenamiento: selectedEstadoEntrenamientoKey.value,
          inGuardia: selectedGuardiaKey.value,
          pageNumber: pageNumber,
          pageSize: pageSize,
          fechaInicio: fechaInicio,
          fechaTermino: fechaTermino);

      if (response.success && response.data != null) {
        var result = response.data as Map<String, dynamic>;

        var items = result['Items'] as List<Monitoring>;
        monitoringAll.assignAll(items);
        currentPage.value = result['PageNumber'] as int;
        totalPages.value = result['TotalPages'] as int;
        totalRecords.value = result['TotalRecords'] as int;
        _logger.severe('Resultados de la búsqueda: ${monitoringAll.length}');
        rowsPerPage.value = result['PageSize'] as int;
        isExpanded.value = false;
      }
    } catch (e, stackTrace) {
      _logger.severe('Error en la búsqueda2: $e', e, stackTrace);
    }
  }

  Future<void> cargarEntrenadores() async {
    try {
      var response = await personalService.listarEntrenadores();

      if (response.success && response.data != null) {
        entrenadores.assignAll(response.data!);
      }
    } catch (e, stackTrace) {
      _logger.severe(
          'Error cargando la data de entrenadores : $e', e, stackTrace);
    }
  }

  Future<void> cargarEstadoEntrenamiento() async {
    try {
      var response = await maestroDetalleService.listarMaestroDetallePorMaestro(
          4); //Catalogo de Estado de Entrenamiento

      if (response.success && response.data != null) {
        estadoEntrenamientoOpciones.assignAll(response.data!);

        _logger.severe(
          'Estado entrenamiento opciones cargadas correctamente: $estadoEntrenamientoOpciones',
        );
      } else {
        _logger.severe('Error: ${response.message}');
      }
    } catch (e, stackTrace) {
      _logger.severe(
          'Error cargando la data de estado entrenamiento maestro: $e',
          e,
          stackTrace);
    }
  }

  Future<void> cargarCondicion() async {
    try {
      var response = await maestroDetalleService.listarMaestroDetallePorMaestro(
          6); //Catalogo de condicion de entrenamiento

      if (response.success && response.data != null) {
        condicionOpciones.assignAll(response.data!);

        _logger.severe(
          'Condicion de entrenamiento opciones cargadas correctamente: $estadoEntrenamientoOpciones',
        );
      } else {
        _logger.severe(
          'Error: ${response.message}',
        );
      }
    } catch (e, stackTrace) {
      _logger.severe(
          'Error cargando la data de condicion de entrenamiento maestro: $e',
          e,
          stackTrace);
    }
  }

  Future<void> cargarModulo() async {
    try {
      var response = await moduloService.listarMaestros();

      if (response.success && response.data != null) {
        moduloOpciones.assignAll(response.data!);

        _logger.severe(
          'Modulos maestro opciones cargadas correctamente: $guardiaOpciones',
        );
      } else {
        _logger.severe(
          'Error: ${response.message}',
        );
      }
    } catch (e, stackTrace) {
      _logger.severe(
          'Error cargando la data de Modulos maestro: $e', e, stackTrace);
    }
  }

  Future<void> cargarEquipo() async {
    try {
      var response = await maestroDetalleService
          .listarMaestroDetallePorMaestro(5); //Maestro de Equipos

      if (response.success && response.data != null) {
        equipoOpciones.assignAll(response.data!);

        _logger.severe(
          'Equipos opciones cargadas correctamente: $equipoOpciones',
        );
      } else {
        _logger.severe('Error: ${response.message}');
      }
    } catch (e, stackTrace) {
      _logger.severe(
          'Error cargando la data de guardia maestro: $e', e, stackTrace);
    }
  }

  Future<void> cargarGuardia() async {
    try {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(2);

      if (response.success && response.data != null) {
        guardiaOpciones.assignAll(response.data!);

        _logger.info(
          'Guardia opciones cargadas correctamente: $guardiaOpciones',
        );
      } else {
        _logger.severe('Error: ${response.message}');
      }
    } catch (e, stackTrace) {
      _logger.severe(
          'Error cargando la data de guardia maestro: $e', e, stackTrace);
    }
  }

  Future<void> downloadExcel() async {
    var response =
        await monitoringService.queryMonitoringPaginated(isPaginate: false);
    if (response.success && response.data != null) {
      var result = response.data as Map<String, dynamic>;

      var items = result['Items'] as List<Monitoring>;
      var excel = Excel.createExcel();
      excel.rename('Sheet1', 'Monitoreo');

      CellStyle headerStyle = CellStyle(
        backgroundColorHex: ExcelColor.blue,
        fontColorHex: ExcelColor.white,
        bold: true,
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
      );
      List<String> headers = [
        'CÓDIGO_MCP',
        'APELLIDO_PATERNO',
        'APELLIDO_MATERNO',
        'NOMBRES',
        'GUARDIA',
        'EQUIPO',
        'ENTRENADOR_RESPONSABLE',
        'CONDICIÓN_MONITOREO',
        'FECHA_REAL_DE_MONITOREO',
        'FECHA_PROXIMO_MONITOREO'
      ];

      for (int i = 0; i < headers.length; i++) {
        var cell = excel.sheets['Monitoreo']!
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
        cell.value = TextCellValue(headers[i]);
        cell.cellStyle = headerStyle;

        excel.sheets['Monitoreo']!
            .setColumnWidth(i, headers[i].length.toDouble() + 5);
      }

      // final dateFormat = DateFormat('dd/MM/yyyy');

      for (int rowIndex = 0; rowIndex < items.length; rowIndex++) {
        var entrenamiento = items[rowIndex];
        List<CellValue> row = [
          TextCellValue(entrenamiento.codigoMcp ?? ""),
          TextCellValue(entrenamiento.apellidoPaterno ?? ""),
          TextCellValue(entrenamiento.apellidoMaterno ?? ""),
          TextCellValue(
              "${entrenamiento.primerNombre} ${entrenamiento.segundoNombre}"),
          TextCellValue(entrenamiento.guardia?.nombre ?? ""),
          TextCellValue(entrenamiento.equipo?.nombre ?? ""),
          TextCellValue(entrenamiento.entrenador?.nombre ?? ""),
          TextCellValue(entrenamiento.condicion?.nombre ?? ""),
          TextCellValue(DateFormat('dd/MM/yyyy')
              .format(entrenamiento.fechaRealMonitoreo!)),
          TextCellValue(""),
        ];

        for (int colIndex = 0; colIndex < row.length; colIndex++) {
          var cell = excel.sheets['Monitoreo']!.cell(CellIndex.indexByColumnRow(
              columnIndex: colIndex, rowIndex: rowIndex + 1));
          cell.value = row[colIndex];

          // double contentWidth = row[colIndex].toString().length.toDouble();
          // if (contentWidth >
          //     excel.sheets['Monitoreo']!.getColumnWidth(colIndex)) {
          //   excel.sheets['Monitoreos']!
          //       .setColumnWidth(colIndex, contentWidth + 5);
          // }
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
  }

  String generateExcelFileName() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year.toString().substring(2);
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');

    return 'MONITOREOS_MINA_$day$month$year$hour$minute$second.xlsx';
  }
}
