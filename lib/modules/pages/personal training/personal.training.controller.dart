import 'dart:developer';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sgem/config/api/api.maestro.detail.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/shared/modules/personal.dart';

class PersonalSearchController extends GetxController {
  final codigoMCPController = TextEditingController();
  final documentoIdentidadController = TextEditingController();
  final nombresController = TextEditingController();
  final apellidosController = TextEditingController();

  final personalService = PersonalService();
  final maestroDetalleService = MaestroDetalleService();

  var showNewPersonalForm = false.obs;
  var showEditPersonalForm = false.obs;
  var showTrainingForm = false.obs;
  var showViewPersonalForm = false.obs;
  var isExpanded = true.obs;

  var personalResults = <Personal>[].obs;
  var selectedPersonal = Rxn<Personal>();
  var guardiaOptions = <Map<String, dynamic>>[].obs;
  var selectedGuardiaKey = RxnInt();

  var rowsPerPage = 0.obs;

  @override
  void onInit() {
    cargarGuardiaOptions();
    super.onInit();
  }

  Future<void> cargarGuardiaOptions() async {
    try {
      var result = await maestroDetalleService.listarMaestroDetalle();
      guardiaOptions.assignAll(result);
      log('Guardia opciones: $guardiaOptions');
    } catch (e) {
      log('Error cargando la data de guardia maestro: $e');
    }
  }

  Future<void> searchPersonal() async {
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
      var result = await personalService.listarPersonalEntrenamiento(
        codigoMcp: codigoMcp,
        numeroDocumento: numeroDocumento,
        nombres: nombres,
        apellidos: apellidos,
        inGuardia: selectedGuardiaKey.value,
        inEstado: null,
      );

      List<Personal> personalList =
          result.map<Personal>((item) => Personal.fromJson(item)).toList();
      personalResults.assignAll(personalList);

      isExpanded.value = false;
      log('Resultados obtenidos: ${personalResults.length}');
    } catch (e) {
      log('Error en la búsqueda: $e');
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
    }

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
            ? DateCellValue.fromDateTime(personal.fechaIngreso!)
            : TextCellValue(''),
        personal.fechaIngresoMina != null
            ? DateCellValue.fromDateTime(personal.fechaIngresoMina!)
            : TextCellValue(''),
        TextCellValue(personal.licenciaConducir),
        TextCellValue(personal.licenciaCategoria),
        personal.licenciaVencimiento != null
            ? DateCellValue.fromDateTime(personal.licenciaVencimiento!)
            : TextCellValue(''),
        TextCellValue(personal.restricciones),
      ];

      for (int colIndex = 0; colIndex < row.length; colIndex++) {
        var cell = excel.sheets['Personal']!.cell(CellIndex.indexByColumnRow(
            columnIndex: colIndex, rowIndex: rowIndex + 1));
        cell.value = row[colIndex];
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

    return 'PERSONAL_MINA_$day$month$year$hour$minute$second.xlsx';
  }

  void clearFields() {
    codigoMCPController.clear();
    documentoIdentidadController.clear();
    nombresController.clear();
    apellidosController.clear();
    selectedGuardiaKey.value = null;
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

    showNewPersonalForm.value = true;
    showEditPersonalForm.value = false;
    showViewPersonalForm.value = false;
  }

  void showEditPersonal(Personal personal) {
    selectedPersonal.value = personal;

    showNewPersonalForm.value = false;
    showEditPersonalForm.value = true;
    showViewPersonalForm.value = false;
  }

  void showViewPersonal(Personal personal) {
    selectedPersonal.value = personal;

    showNewPersonalForm.value = false;
    showEditPersonalForm.value = false;
    showViewPersonalForm.value = true;
  }

  void hideForms() {
    showNewPersonalForm.value = false;
    showEditPersonalForm.value = false;
    showViewPersonalForm.value = false;
    showTrainingForm.value = false;
  }

  void toggleExpansion() {
    isExpanded.value = !isExpanded.value;
  }

  void showTraining() {
    showNewPersonalForm.value = false;
    showEditPersonalForm.value = false;
    showViewPersonalForm.value = false;
    showTrainingForm.value = true;
  }
}
