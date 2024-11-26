import 'dart:async';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';

Future<pw.Page> generateDiploma(Personal? personal) async {
  final image = await loadImage('diploma_full.png');
  final dimensionsImage = await getImageDimensions(image);
  String nombreCompleto = "";
  String cargo = "";

  if (personal != null) {
    nombreCompleto = personal.nombreCompleto!;
    cargo = personal.cargo!;
  }

  final page = pw.Page(
    orientation: pw.PageOrientation.landscape,
    pageFormat: PdfPageFormat.a4.copyWith(
      marginBottom: 0,
      marginLeft: 0,
      marginRight: 0,
      marginTop: 0,
    ),
    build: (pw.Context context) {
      return pw.Container(
        child: pw.Stack(
          children: [
            pw.Image(
              pw.MemoryImage(image),
              fit: pw.BoxFit.contain,
            ),
            pw.Row(
              children: [
                pw.Spacer(),
                pw.Container(
                  padding: const pw.EdgeInsets.only(left: 80),
                  child: pw.Column(
                    children: [
                      pw.SizedBox(height: dimensionsImage.height / 3.1),
                      pw.Text(nombreCompleto,
                          style: const pw.TextStyle(fontSize: 12)),
                      pw.SizedBox(height: dimensionsImage.height / 14),
                      pw.SizedBox(height: 10),
                      pw.Text(cargo, style: const pw.TextStyle(fontSize: 12)),
                      //pw.SizedBox(height: dimensionsImage.height / 16),
                      pw.Container(
                        padding: const pw.EdgeInsets.only(left: 60),
                        alignment: pw.Alignment.center,
                        width: 500,
                        child: pw.Column(
                          children: [
                            pw.SizedBox(height: 10),
                            pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceAround,
                                children: [
                                  userFirm(
                                      "SUPERINTENDENTE DE OPERACIONES MINA"),
                                  userFirm(
                                      "SUPERINTENDENTE DE MEJORA CONTINUA Y CONTROL DE PRODUCCIÓN"),
                                ]),
                            pw.SizedBox(height: dimensionsImage.height / 40),
                            userFirm("GERENTE MINA")
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      );
    },
  );
  return page;
}
