import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/utils/Extensions/pdf.extensions.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';

Future<pw.Page> generatePersonalCarnetFrontPdf(
    Personal? personal, String imageFromAssets, Uint8List? photoPerfil) async {
  final fondoImageBytes = await loadImage(imageFromAssets);
  final imageLogo = await loadImage('logo.png');
  String fechaIngreso = "";
  String nombreCompleto = "";
  String cargo = "";
  String zonaPlataforma = "";
  String operacionMina = "";
  Map<String, String?> attributesMap = {};

  if (personal != null) {
    attributesMap = {
      "Código": personal.codigoMcp,
      "Licencia": personal.licenciaConducir,
      "Categoría": personal.licenciaCategoria,
      "Expira": personal.licenciaVencimiento?.toString(),
      "Área": personal.area,
      "Restricción": personal.restricciones,
    };
    fechaIngreso = personal.fechaIngreso.toString();
    nombreCompleto = personal.nombreCompleto!;
    cargo = personal.cargo!;
    zonaPlataforma = personal.zonaPlataforma!;
    operacionMina = personal.operacionMina!;
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
        decoration: pw.BoxDecoration(
          image: pw.DecorationImage(
            image: pw.MemoryImage(fondoImageBytes),
            fit: pw.BoxFit.cover,
          ),
        ),
        child: pw.Padding(
          padding: const pw.EdgeInsets.all(16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Container(
                padding:
                    const pw.EdgeInsets.only(left: 100, right: 100, top: 80),
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.white,
                    shape: pw.BoxShape.circle,
                  ),
                  child: pw.Container(
                    width: 200,
                    height: 200,
                    child: pw.ClipOval(
                      child: pw.Container(
                        width: 200,
                        height: 200,
                        child: photoPerfil != null
                            ? pw.Image(pw.MemoryImage(photoPerfil),
                                fit: pw.BoxFit.cover)
                            : pw.Text('No image'),
                      ),
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Fecha de emision: $fechaIngreso',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                nombreCompleto,
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
              pw.Container(
                padding:
                    const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                margin: const pw.EdgeInsets.symmetric(vertical: 8),
                color: const PdfColor.fromInt(0xFF81C784),
                child: pw.Text(
                  cargo,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Container(
                padding: const pw.EdgeInsets.only(left: 150),
                child: pw.Column(children: [
                  ...attributesMap.entries
                      .where(
                          (entry) => entry.value != null && entry.value != "")
                      .map((entry) => userDetail(entry.key, entry.value!))
                ]),
              ),
              pw.Spacer(),
              pw.Container(
                padding: const pw.EdgeInsets.only(left: 60, right: 60),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      children: [
                        pw.SizedBox(height: 60),
                        pw.SizedBox(
                          width: 150,
                          child: pw.Divider(color: PdfColors.black),
                        ),
                        pw.Text("Firma del Titular",
                            style: const pw.TextStyle(color: PdfColors.black)),
                      ],
                    ),
                    pw.Container(
                      width: 140,
                      height: 140,
                      child: pw.Image(
                        pw.MemoryImage(imageLogo),
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Text(
                        "Autorizado para operar en:",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue),
                      ),
                      pw.Row(
                        children: [
                          pw.Text('Operaciones mina:'),
                          pw.SizedBox(width: 10),
                          pw.Checkbox(
                              value: operacionMina == 'S', name: "Operaciones"),
                        ],
                      ),
                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Text('Zona de plataforma:',
                          style: const pw.TextStyle(color: PdfColors.white)),
                      pw.SizedBox(width: 10),
                      pw.Checkbox(
                          value: zonaPlataforma == 'S',
                          name: "Zona de plataforma"),
                    ],
                  ),
                ],
              ).padding(
                  const pw.EdgeInsets.only(left: 30, right: 30, bottom: 10)),
            ],
          ),
        ),
      );
    },
  );

  return page;
}
