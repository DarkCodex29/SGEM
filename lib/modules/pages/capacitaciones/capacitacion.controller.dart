import 'dart:developer';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/config/api/api.capacitacion.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/modules/pages/capacitaciones/capacitacion.enum.dart';
import 'package:sgem/shared/modules/capacitacion.consulta.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';
import '../../../config/api/api.maestro.detail.dart';
import '../../../shared/modules/maestro.detail.dart';

class CapacitacionController extends GetxController {
  TextEditingController codigoMcpController = TextEditingController();
  TextEditingController numeroDocumentoController = TextEditingController();
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidoPaternoController = TextEditingController();
  TextEditingController apellidoMaternoController = TextEditingController();
  TextEditingController rangoFechaController = TextEditingController();

  DateTime? fechaInicio;
  DateTime? fechaTermino;

  RxBool isExpanded = true.obs;

  RxBool isLoadingCapacitacion = false.obs;
  RxBool isLoadingCategoria = false.obs;
  RxBool isLoadingEmpresaCapacitacion = false.obs;
  RxBool isLoadingCapacitacionResultados = false.obs;
  RxBool isLoadingEntrenador = false.obs;

  var selectedGuardiaKey = RxnInt();
  var selectedCapacitacionKey = RxnInt();
  var selectedCategoriaKey = RxnInt();
  var selectedEmpresaCapacitacionKey = RxnInt();
  var selectedEntrenadorKey = RxnInt();

  RxList<MaestroDetalle> guardiaOpciones = <MaestroDetalle>[].obs;
  RxList<MaestroDetalle> capacitacionOpciones = <MaestroDetalle>[].obs;
  RxList<MaestroDetalle> categoriaOpciones = <MaestroDetalle>[].obs;
  RxList<MaestroDetalle> empresaCapacitacionOpciones = <MaestroDetalle>[].obs;
  RxList<Personal> entrenadorOpciones = <Personal>[].obs;

  final maestroDetalleService = MaestroDetalleService();
  final personalService = PersonalService();
  final capacitacionService = CapacitacionService();
  RxList<CapacitacionConsulta> capacitacionResultados =
      <CapacitacionConsulta>[].obs;

  var screenPage = CapacitacionScreen.none.obs;

  var rowsPerPage = 10.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalRecords = 0.obs;

  final GenericDropdownController<MaestroDetalle> dropdownController =
      Get.put(GenericDropdownController<MaestroDetalle>());
  final GenericDropdownController<Personal> personalDropdownController =
      Get.put(GenericDropdownController<Personal>());

  Rxn<CapacitacionConsulta> selectedCapacitacion = Rxn<CapacitacionConsulta>();

  @override
  void onInit() {
    cargarDropdowns();
    buscarCapacitaciones(
        pageNumber: currentPage.value, pageSize: rowsPerPage.value);
    super.onInit();
  }

  void cargarDropdowns() {
    dropdownController.loadOptions('guardia', () async {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(2);
      return response.success && response.data != null
          ? response.data!
          : <MaestroDetalle>[];
    });

    dropdownController.loadOptions('categoria', () async {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(9);
      return response.success && response.data != null
          ? response.data!
          : <MaestroDetalle>[];
    });

    dropdownController.loadOptions('empresaCapacitacion', () async {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(8);
      return response.success && response.data != null
          ? response.data!
          : <MaestroDetalle>[];
    });

    dropdownController.loadOptions('capacitacion', () async {
      var response =
          await maestroDetalleService.listarMaestroDetallePorMaestro(7);
      return response.success && response.data != null
          ? response.data!
          : <MaestroDetalle>[];
    });

    personalDropdownController.loadOptions('entrenador', () async {
      var response = await personalService.listarEntrenadores();
      return response.success && response.data != null
          ? response.data!
          : <Personal>[];
    });
  }

  Future<void> buscarCapacitaciones(
      {int pageNumber = 1, int pageSize = 10}) async {
    String? codigoMcp =
        codigoMcpController.text.isEmpty ? null : codigoMcpController.text;
    String? numeroDocumento = numeroDocumentoController.text.isEmpty
        ? null
        : numeroDocumentoController.text;
    String? nombres =
        nombresController.text.isEmpty ? null : nombresController.text;
    String? apellidoPaterno = apellidoPaternoController.text.isEmpty
        ? null
        : apellidoPaternoController.text;
    String? apellidoMaterno = apellidoMaternoController.text.isEmpty
        ? null
        : apellidoMaternoController.text;
    try {
      var response = await capacitacionService.CapacitacionConsultaPaginado(
        codigoMcp: codigoMcp,
        numeroDocumento: numeroDocumento,
        inGuardia: selectedGuardiaKey.value,
        nombres: nombres,
        apellidoPaterno: apellidoPaterno,
        apellidoMaterno: apellidoMaterno,
        inCapacitacion: selectedCapacitacionKey.value,
        inCategoria: selectedCategoriaKey.value,
        inEmpresaCapacitacion: selectedEmpresaCapacitacionKey.value,
        inEntrenador: selectedEntrenadorKey.value,
        fechaInicio: fechaInicio,
        fechaTermino: fechaTermino,
        pageSize: pageSize,
        pageNumber: pageNumber,
      );

      if (response.success && response.data != null) {
        try {
          var result = response.data as Map<String, dynamic>;
          log('Respuesta recibida correctamente $result');

          var items = result['Items'] as List<CapacitacionConsulta>;
          log('Items obtenidos: $items');

          capacitacionResultados.assignAll(items);

          currentPage.value = result['PageNumber'] as int;
          totalPages.value = result['TotalPages'] as int;
          totalRecords.value = result['TotalRecords'] as int;
          rowsPerPage.value = result['PageSize'] as int;
          isExpanded.value = false;

          log('Resultados obtenidos: ${capacitacionResultados.length}');
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
    excel.rename('Sheet1', 'Capacitacion');

    CellStyle headerStyle = CellStyle(
      backgroundColorHex: ExcelColor.blue,
      fontColorHex: ExcelColor.white,
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );
    List<String> headers = [
      'CODIGO_MCP',
      'NOMBRES_APELLIDOS',
      'GUARDIA',
      'ENTRENADOR_RESPONSABLE',
      'NOMBRE_CAPACITACION',
      'CATEGORIA',
      'EMPRESA_CAPACITACION',
      'FECHA_INICIO',
      'FECHA_TERMINO',
      'HORAS',
      'NOTA_TEÓRICA',
      'NOTA_PRÁCTICA'
    ];

    for (int i = 0; i < headers.length; i++) {
      var cell = excel.sheets['Capacitacion']!
          .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;

      excel.sheets['Capacitacion']!
          .setColumnWidth(i, headers[i].length.toDouble() + 5);
    }

    final dateFormat = DateFormat('dd/MM/yyyy');

    for (int rowIndex = 0;
        rowIndex < capacitacionResultados.length;
        rowIndex++) {
      var entrenamiento = capacitacionResultados[rowIndex];
      List<CellValue> row = [
        TextCellValue(entrenamiento.codigoMcp!),
        TextCellValue(entrenamiento.nombreCompleto!),
        TextCellValue(entrenamiento.guardia.nombre!),
        TextCellValue(entrenamiento.entrenador.nombre!),
        TextCellValue(' '), //Nombre capacitacion
        TextCellValue(entrenamiento.categoria.nombre!),
        TextCellValue(entrenamiento.empresaCapacitadora.nombre!),
        entrenamiento.fechaInicio != null
            ? TextCellValue(dateFormat.format(entrenamiento.fechaInicio!))
            : TextCellValue(''),
        entrenamiento.fechaTermino != null
            ? TextCellValue(dateFormat.format(entrenamiento.fechaTermino!))
            : TextCellValue(''),
        TextCellValue(entrenamiento.inTotalHoras.toString()),
        TextCellValue(entrenamiento.inNotaTeorica.toString()),
        TextCellValue(entrenamiento.inNotaPractica.toString()),
      ];

      for (int colIndex = 0; colIndex < row.length; colIndex++) {
        var cell = excel.sheets['Capacitacion']!.cell(
            CellIndex.indexByColumnRow(
                columnIndex: colIndex, rowIndex: rowIndex + 1));
        cell.value = row[colIndex];

        double contentWidth = row[colIndex].toString().length.toDouble();
        if (contentWidth >
            excel.sheets['Capacitacion']!.getColumnWidth(colIndex)) {
          excel.sheets['Capacitacion']!
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

    return 'CAPACITACIONES_MINA_$day$month$year$hour$minute$second';
  }

  void showNuevaCapacitacion() {
    screenPage.value = CapacitacionScreen.nuevaCapacitacion;
  }

  void showCargaMasivaCapacitacion() {
    screenPage.value = CapacitacionScreen.cargaMasivaCapacitacion;
  }

  void showEditarCapacitacion(int capacitacionKey) {
    screenPage.value = CapacitacionScreen.editarCapacitacion;
  }

  void showCapacitacionPage() {
    screenPage.value = CapacitacionScreen.none;
  }

  Future<bool> eliminarCapacitacion(
      EntrenamientoModulo capacitacion, String motivoEliminacion) async {
    try {
      capacitacion.motivoEliminado = motivoEliminacion;

      final response = await capacitacionService.eliminarModulo(capacitacion);
      if (response.success) {
        log('Capacitación eliminada con éxito');
        return true;
      } else {
        log('Error al eliminar la capacitación: ${response.message}');
        return false;
      }
    } catch (e) {
      log('Error al eliminar la capacitación: $e');
      return false;
    }
  }

  void clearFields() {
    codigoMcpController.clear();
    numeroDocumentoController.clear();
    selectedGuardiaKey.value = null;
    nombresController.clear();
    apellidoPaternoController.clear();
    apellidoMaternoController.clear();
    selectedCapacitacionKey.value = null;
    selectedCategoriaKey.value = null;
    selectedEmpresaCapacitacionKey.value = null;
    selectedEntrenadorKey.value = null;
    rangoFechaController.clear();
    fechaInicio = null;
    fechaTermino = null;
  }
}
