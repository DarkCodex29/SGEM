import 'package:excel/excel.dart';
import 'package:sgem/shared/utils/functions/parse.date.time.dart';

class CapacitacionCargaMasivaExcel {
  String codigo;
  String dni;
  String nombres;
  String guardia;
  int? codigoEntrenador;
  String entrenador;
  String nombreCapacitacion;
  String categoria;
  String empresa;
  DateTime? fechaInicio;
  DateTime? fechaTermino;
  int? horas;
  int? notaTeorica;
  int? notaPractica;

  CapacitacionCargaMasivaExcel({
    required this.codigo,
    required this.dni,
    required this.nombres,
    required this.guardia,
    this.codigoEntrenador,
    required this.entrenador,
    required this.nombreCapacitacion,
    required this.categoria,
    required this.empresa,
    this.fechaInicio,
    this.fechaTermino,
    this.horas,
    this.notaTeorica,
    this.notaPractica,
  });

  factory CapacitacionCargaMasivaExcel.fromExcelRow(List<Data?> row) {
    String codigo = row[0]?.value.toString() ?? '';
    String dni = row[1]?.value.toString() ?? '';
    String nombres = row[2]?.value.toString() ?? '';
    String guardia = row[3]?.value.toString() ?? '';
    int? codigoEntrenador =
    row[4]?.value != null ? int.parse(row[4]!.value.toString()) : null;
    String entrenador = row[5]?.value.toString() ?? '';
    String nombreCapacitacion = row[6]?.value.toString() ?? '';
    String categoria = row[7]?.value.toString() ?? '';
    String empresa = row[8]?.value.toString() ?? '';
    DateTime? fechaInicio =
        row[9]?.value != null ? DateTime.parse(row[9]!.value.toString()) : null;
    DateTime? fechaTermino =
        row[10]?.value != null ? DateTime.parse(row[10]!.value.toString()) : null;
    int? horas =
        row[11]?.value != null ? int.parse(row[11]!.value.toString()) : null;
    int? notaTeorica =
        row[12]?.value != null ? int.parse(row[12]!.value.toString()) : null;
    int? notaPractica =
        row[13]?.value != null ? int.parse(row[13]!.value.toString()) : null;

    return CapacitacionCargaMasivaExcel(
      codigo: codigo,
      dni: dni,
      nombres: nombres,
      guardia: guardia,
      codigoEntrenador: codigoEntrenador,
      entrenador: entrenador,
      nombreCapacitacion: nombreCapacitacion,
      categoria: categoria,
      empresa: empresa,
      fechaInicio: fechaInicio,
      fechaTermino: fechaTermino,
      horas: horas,
      notaTeorica: notaTeorica,
      notaPractica: notaPractica,
    );
  }

  Map<String, dynamic> toJson() => {
        "Codigo": codigo,
        "Dni": dni,
        "Nombres": nombres,
        "Guardia": guardia,
        "CodigoEntrenador": codigoEntrenador,
        "Entrenador": entrenador,
        "NombreCapacitacion": nombreCapacitacion,
        "Categoria": categoria,
        "Empresa": empresa,
        "FechaInicio": FnDateTime.toDotNetDate(fechaInicio!),
        "FechaTermino": FnDateTime.toDotNetDate(fechaTermino!),
        "Horas": horas,
        "NotaTeorica": notaTeorica,
        "NotaPractica": notaPractica,
      };

}
