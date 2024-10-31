import 'package:excel/excel.dart';

class CapacitacionCargaMasivaExcel {
   String codigo;
   String dni;
   String nombres;
   String guardia;
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
    String entrenador = row[4]?.value.toString() ?? '';
    String nombreCapacitacion = row[5]?.value.toString() ?? '';
    String categoria = row[6]?.value.toString() ?? '';
    String empresa = row[7]?.value.toString() ?? '';
    DateTime? fechaInicio =
        row[8]?.value != null ? DateTime.parse(row[8]!.value.toString()) : null;
    DateTime? fechaTermino =
        row[9]?.value != null ? DateTime.parse(row[9]!.value.toString()) : null;
    int? horas =
        row[10]?.value != null ? int.parse(row[10]!.value.toString()) : null;
    int? notaTeorica =
        row[11]?.value != null ? int.parse(row[11]!.value.toString()) : null;
    int? notaPractica =
        row[12]?.value != null ? int.parse(row[12]!.value.toString()) : null;

    return CapacitacionCargaMasivaExcel(
      codigo: codigo,
      dni: dni,
      nombres: nombres,
      guardia: guardia,
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
     "Entrenador": entrenador,
     "NombreCapacitacion": nombreCapacitacion,
     "Categoria": categoria,
     "Empresa": empresa,
     "FechaInicio": fechaInicio?.toIso8601String(),
     "FechaTermino": fechaTermino?.toIso8601String(),
     "Horas": horas,
     "NotaTeorica": notaTeorica,
     "NotaPractica": notaPractica,
   };
}
