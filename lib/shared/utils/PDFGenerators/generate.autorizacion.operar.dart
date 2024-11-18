import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:sgem/config/api/api.entrenamiento.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';

Future<pw.Page> generatePersonalCarnetBackPdf(
    Personal? personal, String imageFromAssets, String title) async {
  final fondoImageBytes = await loadImage(imageFromAssets);
  final EntrenamientoService entrenamientoService = EntrenamientoService();
  var trainingListEntrenando = <EntrenamientoModulo>[];
  var trainingListAutorizado = <EntrenamientoModulo>[];

  Future<void> fetchTrainings() async {
    if (personal != null && personal.key != null) {
      final response = await entrenamientoService
          .listarEntrenamientoPorPersona(personal.key!);

      if (response.success) {
        final allTrainings = response.data!
            .map((json) => EntrenamientoModulo.fromJson(json))
            .toList();

        trainingListEntrenando = allTrainings
            .where((training) =>
                training.estadoEntrenamiento?.nombre == "Entrenando")
            .toList();

        trainingListAutorizado = allTrainings
            .where((training) =>
                training.estadoEntrenamiento?.nombre == "Autorizado")
            .toList();
      }
    }
  }

  await fetchTrainings();

  List<EntrenamientoModulo> trainingListToShow;
  String listTitle;
  if (title == "AUTORIZADO PARA OPERAR") {
    trainingListToShow = trainingListAutorizado;
    listTitle = "Equipos Autorizados";
  } else if (title == "AUTORIZADO PARA ENTRENAR") {
    trainingListToShow = trainingListEntrenando;
    listTitle = "Equipos Entrenando";
  } else {
    trainingListToShow = [];
    listTitle = "Sin equipos disponibles";
  }

  final page = pw.Page(
    pageFormat: PdfPageFormat.a4.copyWith(
      marginBottom: 0,
      marginLeft: 0,
      marginRight: 0,
      marginTop: 0,
    ),
    build: (pw.Context context) {
      return pw.Container(
        padding: const pw.EdgeInsets.all(0),
        decoration: pw.BoxDecoration(
          image: pw.DecorationImage(
            image: pw.MemoryImage(fondoImageBytes),
            fit: pw.BoxFit.fill,
          ),
        ),
        child: pw.Padding(
          padding: const pw.EdgeInsets.all(70),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.SizedBox(height: 100),
              pw.Text(
                title,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Container(
                margin: const pw.EdgeInsets.symmetric(vertical: 8),
                padding:
                    const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: const pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFF81C784),
                ),
                child: pw.Text(
                  "GUARDIA: ${personal!.guardia?.nombre ?? 'Sin guardia'}",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Container(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  listTitle,
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              _buildTrainingList(trainingListToShow),
              pw.Spacer(),
              pw.Container(
                  padding:
                      const pw.EdgeInsets.only(bottom: 50, right: 40, left: 40),
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        userFirm("Entrenador Operaciones Mina"),
                        userFirm("Superintendente de Mejora Continua")
                      ]))
            ],
          ),
        ),
      );
    },
    margin: pw.EdgeInsets.zero,
  );
  return page;
}

pw.Widget _buildTrainingList(List<EntrenamientoModulo> trainingList) {
  if (trainingList.isEmpty) {
    return pw.Text(
      "No tiene equipos asignados.",
      textAlign: pw.TextAlign.center,
      style: const pw.TextStyle(color: PdfColors.grey, fontSize: 14),
    );
  }

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: trainingList.map((training) {
      return pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 5),
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
          training.equipo?.nombre ?? 'Equipo desconocido',
          style: const pw.TextStyle(fontSize: 14),
        ),
      );
    }).toList(),
  );
}
