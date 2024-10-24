import 'dart:developer';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sgem/config/api/api.maestro.detail.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';

enum PersonalSearchScreen {
  none,
  newPersonal,
  editPersonal,
  trainingForm,
  viewPersonal,
  carnetPersonal,
  diplomaPersonal,
  certificadoPersonal,
  actualizacionMasiva
}

extension PersonalSearchScreenExtension on PersonalSearchScreen {
  String description() {
    switch (this) {
      case PersonalSearchScreen.none:
        return "";
      case PersonalSearchScreen.newPersonal:
        return "Nuevo personal a Entrenar";
      case PersonalSearchScreen.editPersonal:
        return "Editar Personal";
      case PersonalSearchScreen.trainingForm:
        return "Búsqueda de entrenamiento de personal";
      case PersonalSearchScreen.viewPersonal:
        return "Visualizar";
      case PersonalSearchScreen.carnetPersonal:
        return "Carnet del Personal";
      case PersonalSearchScreen.actualizacionMasiva:
        return "Actualizacion Masiva";
      default:
        return "Entrenamientos";
    }
  }
}

class PersonalSearchController extends GetxController {
  final codigoMCPController = TextEditingController();
  final documentoIdentidadController = TextEditingController();
  final nombresController = TextEditingController();
  final apellidosController = TextEditingController();
  final expansionController = ExpansionTileController();

  final personalService = PersonalService();
  final maestroDetalleService = MaestroDetalleService();

  RxBool isExpanded = true.obs;
  var screen = PersonalSearchScreen.none.obs;

  var personalResults = <Personal>[].obs;
  var selectedPersonal = Rxn<Personal>();
  RxList<MaestroDetalle> guardiaOptions = <MaestroDetalle>[].obs;
  var selectedGuardiaKey = RxnInt();
  var selectedEstadoKey = RxnInt(95);

  var rowsPerPage = 10.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalRecords = 0.obs;

  var isLoadingGuardia = false.obs;
  final GenericDropdownController<MaestroDetalle> dropdownController =
      Get.put(GenericDropdownController<MaestroDetalle>());

  @override
  void onInit() {
    //cargarGuardiaOptions();
    searchPersonal(pageNumber: currentPage.value, pageSize: rowsPerPage.value);
    super.onInit();
  }

  Future<Uint8List?> loadPersonalPhoto(int idOrigen) async {
    try {
      final photoResponse =
          await personalService.obtenerFotoPorCodigoOrigen(idOrigen);
      if (photoResponse.success && photoResponse.data != null) {
        return photoResponse.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  void cargarDropdowns() {
    dropdownController.loadOptions('guardia', () async {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(2);
      return response.success && response.data != null
          ? response.data!
          : <MaestroDetalle>[];
    });
  }
/*
  Future<void> cargarGuardiaOptions() async {
    isLoadingGuardia.value = true;
    try {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(2);

      if (response.success && response.data != null) {
        guardiaOptions.assignAll(response.data!);
        log('Guardia opciones cargadas correctamente: $guardiaOptions');
      } else {
        log('Error: ${response.message}');
      }
    } catch (e) {
      log('Error cargando la data de guardia maestro: $e');
    } finally {
      isLoadingGuardia.value = false;
    }
  }
  */

  void searchPersonalEstado(int? estadoKey) {
    selectedEstadoKey.value = estadoKey;
  }

  Future<void> searchPersonal({int pageNumber = 1, int pageSize = 10}) async {
    String? codigoMcp =
        codigoMCPController.text.isEmpty ? null : codigoMCPController.text;
    String? numeroDocumento = documentoIdentidadController.text.isEmpty
        ? null
        : documentoIdentidadController.text;
    String? nombres =
        nombresController.text.isEmpty ? null : nombresController.text;
    String? apellidos =
        apellidosController.text.isEmpty ? null : apellidosController.text;

    try {
      var response = await personalService.listarPersonalEntrenamientoPaginado(
        codigoMcp: codigoMcp,
        numeroDocumento: numeroDocumento,
        nombres: nombres,
        apellidos: apellidos,
        inGuardia: selectedGuardiaKey.value,
        inEstado: selectedEstadoKey.value,
        pageSize: pageSize,
        pageNumber: pageNumber,
      );

      if (response.success && response.data != null) {
        try {
          var result = response.data as Map<String, dynamic>;
          log('Respuesta recibida correctamente: $result');

          var items = result['Items'] as List<Personal>;
          log('Items obtenidos: $items');

          personalResults.assignAll(items);

          currentPage.value = result['PageNumber'] as int;
          totalPages.value = result['TotalPages'] as int;
          totalRecords.value = result['TotalRecords'] as int;
          rowsPerPage.value = result['PageSize'] as int;
          isExpanded.value = false;

          log('Resultados obtenidos: ${personalResults.length}');
        } catch (e) {
          log('Error al procesar la respuesta: $e');
        }
      } else {
        log('Error en la búsqueda: ${response.message}');
      }
    } catch (e) {
      log('Error en la búsqueda2: $e');
    }
  }

  Future<void> downloadExcel() async {
    var excel = Excel.createExcel();
    excel.rename('Sheet1', 'Personal');

    CellStyle headerStyle = CellStyle(
      backgroundColorHex: ExcelColor.blue,
      fontColorHex: ExcelColor.white,
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );
    List<String> headers = [
      'DNI',
      'CÓDIGO',
      'APELLIDO PATERNO',
      'APELLIDO MATERNO',
      'NOMBRES',
      'GUARDIA',
      'PUESTO TRABAJO',
      'GERENCIA',
      'ÁREA',
      'FECHA INGRESO',
      'FECHA INGRESO MINA',
      'CÓDIGO LICENCIA',
      'CATEGORÍA LICENCIA',
      'FECHA REVALIDACIÓN',
      'RESTRICCIONES'
    ];

    for (int i = 0; i < headers.length; i++) {
      var cell = excel.sheets['Personal']!
          .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;

      excel.sheets['Personal']!
          .setColumnWidth(i, headers[i].length.toDouble() + 5);
    }

    final dateFormat = DateFormat('dd/MM/yyyy');

    for (int rowIndex = 0; rowIndex < personalResults.length; rowIndex++) {
      var personal = personalResults[rowIndex];
      List<CellValue> row = [
        TextCellValue(personal.numeroDocumento),
        TextCellValue(personal.codigoMcp),
        TextCellValue(personal.apellidoPaterno),
        TextCellValue(personal.apellidoMaterno),
        TextCellValue('${personal.primerNombre} ${personal.segundoNombre}'),
        TextCellValue(personal.guardia.nombre),
        TextCellValue(personal.cargo),
        TextCellValue(personal.gerencia),
        TextCellValue(personal.area),
        personal.fechaIngreso != null
            ? TextCellValue(dateFormat.format(personal.fechaIngreso!))
            : TextCellValue(''),
        personal.fechaIngresoMina != null
            ? TextCellValue(dateFormat.format(personal.fechaIngresoMina!))
            : TextCellValue(''),
        TextCellValue(personal.licenciaConducir),
        TextCellValue(personal.licenciaCategoria),
        personal.licenciaVencimiento != null
            ? TextCellValue(dateFormat.format(personal.licenciaVencimiento!))
            : TextCellValue(''),
        TextCellValue(personal.restricciones),
      ];

      for (int colIndex = 0; colIndex < row.length; colIndex++) {
        var cell = excel.sheets['Personal']!.cell(CellIndex.indexByColumnRow(
            columnIndex: colIndex, rowIndex: rowIndex + 1));
        cell.value = row[colIndex];

        double contentWidth = row[colIndex].toString().length.toDouble();
        if (contentWidth > excel.sheets['Personal']!.getColumnWidth(colIndex)) {
          excel.sheets['Personal']!.setColumnWidth(colIndex, contentWidth + 5);
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

    return 'PERSONAL_MINA_$day$month$year$hour$minute$second';
  }

  void clearFields() {
    codigoMCPController.clear();
    documentoIdentidadController.clear();
    nombresController.clear();
    apellidosController.clear();
    selectedGuardiaKey.value = null;
    selectedEstadoKey.value = null;
  }

  void showNewPersonal() {
    selectedPersonal.value = Personal(
      key: 0,
      tipoPersona: "",
      inPersonalOrigen: 0,
      licenciaConducir: "",
      operacionMina: "",
      zonaPlataforma: "",
      restricciones: "",
      usuarioRegistro: "",
      usuarioModifica: "",
      codigoMcp: "",
      nombreCompleto: "",
      cargo: "",
      numeroDocumento: "",
      guardia: Guardia(key: 0, nombre: ""),
      estado: Estado(key: 0, nombre: ""),
      eliminado: "",
      motivoElimina: "",
      usuarioElimina: "",
      apellidoPaterno: "",
      apellidoMaterno: "",
      primerNombre: "",
      segundoNombre: "",
      fechaIngreso: null,
      licenciaCategoria: "",
      licenciaVencimiento: null,
      gerencia: "",
      area: "",
    );

    screen.value = PersonalSearchScreen.newPersonal;
  }

  void showEditPersonal(Personal personal) {
    selectedPersonal.value = personal;

    screen.value = PersonalSearchScreen.editPersonal;
  }

  void showViewPersonal(Personal personal) {
    selectedPersonal.value = personal;

    screen.value = PersonalSearchScreen.viewPersonal;
  }

  void hideForms() {
    screen.value = PersonalSearchScreen.none;
  }

  void toggleExpansion() {
    isExpanded.value = !isExpanded.value;
  }

  void showTraining(Personal personal) {
    selectedPersonal.value = personal;
    screen.value = PersonalSearchScreen.trainingForm;
  }

  void showActualizacionMasiva() {
    screen.value = PersonalSearchScreen.actualizacionMasiva;
  }

  void showCarnet(Personal personal) {
    selectedPersonal.value = personal;
    screen.value = PersonalSearchScreen.carnetPersonal;
  }

  void showDiploma() {
    screen.value = PersonalSearchScreen.diplomaPersonal;
  }

  void showCertificado() {
    screen.value = PersonalSearchScreen.certificadoPersonal;
  }
}
