import 'dart:developer';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sgem/config/api/api.entrenamiento.dart';
import 'package:sgem/shared/dialogs/rango.fecha.dialog.dart';
import 'package:sgem/shared/modules/entrenamiento.consulta.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';

class ConsultaEntrenamientoController extends GetxController {
  TextEditingController codigoMcpController = TextEditingController();
  TextEditingController rangoFechaController = TextEditingController();
  TextEditingController nombresController = TextEditingController();

  DateTime? fechaInicio;
  DateTime? fechaTermino;

  final entrenamientoService = EntrenamientoService();

  RxBool isExpanded = true.obs;
  var entrenamientoResultados = <EntrenamientoConsulta>[].obs;

  var rowsPerPage = 10.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalRecords = 0.obs;

  final GenericDropdownController dropdownController =
      Get.find<GenericDropdownController>();

  @override
  void onInit() {
    super.onInit();
    dropdownController.selectValueKey('guardiaFiltro', 0);
    buscarEntrenamientos(
        pageNumber: currentPage.value, pageSize: rowsPerPage.value);
  }

  Future<void> buscarEntrenamientos(
      {int pageNumber = 1, int pageSize = 10}) async {
    String? codigoMcp =
        codigoMcpController.text.isEmpty ? null : codigoMcpController.text;
    String? nombres =
        nombresController.text.isEmpty ? null : nombresController.text;
    try {
      //log('${}');
      var response = await entrenamientoService.consultarEntrenamientoPaginado(
        codigoMcp: codigoMcp,
        inEquipo: dropdownController.getSelectedValue('equipo')?.key,
        inModulo: dropdownController.getSelectedValue('modulo')?.key,
        inGuardia:
            dropdownController.getSelectedValue('guardiaFiltro')?.key == 0
                ? null
                : dropdownController.getSelectedValue('guardiaFiltro')?.key,
        inEstadoEntrenamiento:
            dropdownController.getSelectedValue('estadoEntrenamiento')?.key,
        inCondicion: dropdownController.getSelectedValue('condicion')?.key,
        fechaInicio: fechaInicio,
        fechaTermino: fechaTermino,
        nombres: nombres,
        pageSize: pageSize,
        pageNumber: pageNumber,
      );
      log('Termino consulta');
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
    try {
      // Obtener todos los registros del backend (sin paginación)
      var response = await entrenamientoService.consultarEntrenamientoPaginado(
        codigoMcp: codigoMcpController.text.isEmpty ? null : codigoMcpController.text,
        inEquipo: dropdownController.getSelectedValue('equipo')?.key,
        inModulo: dropdownController.getSelectedValue('modulo')?.key,
        inGuardia: dropdownController.getSelectedValue('guardiaFiltro')?.key == 0
            ? null
            : dropdownController.getSelectedValue('guardiaFiltro')?.key,
        inEstadoEntrenamiento:
            dropdownController.getSelectedValue('estadoEntrenamiento')?.key,
        inCondicion: dropdownController.getSelectedValue('condicion')?.key,
        fechaInicio: fechaInicio,
        fechaTermino: fechaTermino,
        nombres: nombresController.text.isEmpty ? null : nombresController.text,
        pageSize: totalRecords.value, // Traer todos los registros
        pageNumber: 1, // Primera página
      );

      if (response.success && response.data != null) {
        // Asignar todos los registros al listado para exportar
        var result = response.data as Map<String, dynamic>;
        var items = result['Items'] as List<EntrenamientoConsulta>;

        // Crear el archivo Excel
        var excel = Excel.createExcel();
        excel.rename('Sheet1', 'Entrenamiento');

        // Agregar cabeceras
        List<String> headers = [
          'CODIGO_MCP',
          'NOMBRES Y APELLIDOS',
          'GUARDIA',
          'ESTADO_ENTRENAMIENTO',
          'ESTADO_AVANCE',
          'CONDICIÓN',
          'EQUIPO',
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
          cell.value = TextCellValue(headers[i]); // Asegurar tipo TextCellValue
        }

        // Agregar filas
        final dateFormat = DateFormat('dd/MM/yyyy');
        for (int rowIndex = 0; rowIndex < items.length; rowIndex++) {
          var entrenamiento = items[rowIndex];
          List<TextCellValue> row = [
            TextCellValue(entrenamiento.codigoMcp ?? ''),
            TextCellValue(entrenamiento.nombreCompleto ?? ''),
            TextCellValue(entrenamiento.guardia?.nombre ?? ''),
            TextCellValue(entrenamiento.estadoEntrenamiento?.nombre ?? ''),
            TextCellValue(entrenamiento.modulo?.nombre ?? ''),
            TextCellValue(entrenamiento.condicion?.nombre ?? ''),
            TextCellValue(entrenamiento.equipo?.nombre ?? ''),
            TextCellValue(entrenamiento.fechaInicio != null
                ? dateFormat.format(entrenamiento.fechaInicio!)
                : ''),
            TextCellValue(entrenamiento.fechaTermino != null
                ? dateFormat.format(entrenamiento.fechaTermino!)
                : ''),
            TextCellValue(entrenamiento.entrenador?.nombre ?? ''),
            TextCellValue(entrenamiento.notaTeorica?.toString() ?? ''),
            TextCellValue(entrenamiento.notaPractica?.toString() ?? ''),
            TextCellValue(entrenamiento.horasAcumuladas?.toString() ?? ''),
          ];

          for (int colIndex = 0; colIndex < row.length; colIndex++) {
            var cell = excel.sheets['Entrenamiento']!.cell(
                CellIndex.indexByColumnRow(
                    columnIndex: colIndex, rowIndex: rowIndex + 1));
            cell.value = row[colIndex];
          }
        }

        // Convertir a bytes y descargar
        var excelBytes = excel.encode();
        if (excelBytes != null) {
          Uint8List uint8ListBytes = Uint8List.fromList(excelBytes);
          String fileName = generateExcelFileName();

          await FileSaver.instance.saveFile(
            name: fileName,
            bytes: uint8ListBytes,
            ext: "xlsx",
            mimeType: MimeType.microsoftExcel,
          );

          Get.snackbar('Éxito', 'Archivo Excel descargado correctamente');
        }
      } else {
        Get.snackbar('Error', 'No se pudo obtener los datos para exportar');
      }
    } catch (e) {
      log('Error al generar Excel: $e');
      Get.snackbar('Error', 'No se pudo generar el archivo Excel');
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

    return 'ENTRENAMIENTOS_MINA_$day$month$year$hour$minute$second';
  }

  void resetControllers() {
    codigoMcpController.clear();
    rangoFechaController.clear();
    fechaInicio = null;
    fechaTermino = null;
    nombresController.clear();
    dropdownController.resetAllSelections();
    dropdownController.selectValueKey('guardiaFiltro', 0);
  }

  Future<void> seleccionarFecha(BuildContext context) async {
    DateTimeRange? rangoFechaSeleccionado;

    if (fechaInicio != null && fechaTermino != null){
      rangoFechaSeleccionado = DateTimeRange(
        start: fechaInicio!,
        end: fechaTermino!,
      );
    }

    var seleccionado = await mostrarRangoFecha(context,rangoFechaSeleccionado);
    if (seleccionado != null) {
      rangoFechaController.text =
          '${DateFormat('dd/MM/yyyy').format(seleccionado.start)} - ${DateFormat('dd/MM/yyyy').format(seleccionado.end)}';
      fechaInicio = seleccionado.start;
      fechaTermino = seleccionado.end;
    }
  }
}
