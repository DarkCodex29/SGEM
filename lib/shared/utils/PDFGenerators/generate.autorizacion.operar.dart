import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';

Future<pw.Page> generatePersonalCarnetBackPdf(Personal? personal, String imageFromAssets) async {
  final fondoImageBytes = await loadImage(imageFromAssets);
  Map<String, String?> attributesMap = {};

  String guardia = "";

    if(personal != null) {
        attributesMap = {
        "Código": personal.codigoMcp,
        "Licencia": personal.licenciaConducir,
        "Categoría": personal.licenciaCategoria,
        "Expira": personal.licenciaVencimiento?.toString(),
        "Área": personal.area,
        "Restricción": personal.restricciones,
      };
      guardia = personal.guardia.nombre;
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
            child:
              pw.Padding(
                padding: const pw.EdgeInsets.all(70),
                child: pw.Column(
                  children: [
                    pw.SizedBox(height: 70),
                    pw.Text(
                      "AUTORIZACION PARA OPERAR",
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      )),

                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      margin: const pw.EdgeInsets.symmetric(vertical: 8),
                      color: const PdfColor.fromInt(0xFF81C784),
                      child: pw.Text(
                        "GUARDIA: $guardia",
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),

                    pw.SizedBox(height: 10),

                    pw.Row(
                      children: [
                        pw.Text(
                          "Equipos Moviles",
                            style: pw.TextStyle(
                              color: PdfColors.black,
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold
                            )
                        ),
                        pw.Spacer()
                      ]
                    ),

                    pw.SizedBox(height: 20),

                    pw.Container(
                      alignment: pw.Alignment.centerLeft,
                      height: 300,
                      width: 450,
                      padding: const pw.EdgeInsets.all(24),
                      decoration: const pw.BoxDecoration(
                        color: PdfColor(0.94, 0.94, 0.94),  // Fondo gris claro (similar al de la imagen)
                        borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),  // Bordes redondeados
                      ),
                      child: pw.Row(
                        children: [
                          pw.Container(
                            alignment: pw.Alignment.centerLeft,
                            width: 225,
                            child: 
                              pw.Column(
                                children: [
                                  ...attributesMap.entries
                                    .where((entry) => entry.value != null && entry.value != "")
                                    .map((entry) => _equipoMovilText(entry.value!)),
                                ]
                              ),
                          ),
                        ]
                      )
                    ),

                    pw.Spacer(),

                    pw.Container(
                      padding: const pw.EdgeInsets.only(bottom: 50, right: 40, left: 40),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          userFirm("Entrenador Operaciones Mina"),
                          userFirm("Superintendente de Mejora Continua")
                        ]
                      )

                    )
                  ]
                )
              )
          );
        },
        margin: pw.EdgeInsets.zero,
    );
    return page;
}

pw.Widget _equipoMovilText(String label) {
  return pw.Container(
    alignment: pw.Alignment.centerLeft,
    child: pw.Text(
      label,
      textAlign: pw.TextAlign.left,
      style: const pw.TextStyle(
        color: PdfColors.grey,
        fontSize: 16,
      ) 
    )
  );
}

