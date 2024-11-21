import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:sgem/shared/modules/entrenamiento.modulo.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/utils/Extensions/pdf.extensions.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';

Future<pw.Page> generateCertificado(
    Personal? personal,
    EntrenamientoModulo? entrenamiento,
    Map<int, RxList<EntrenamientoModulo>> modulosPorEntrenamiento) async {
      
  const horamodulo1 = 5;
  const horamodulo2 = 10;
  const totalHoras = horamodulo1 + horamodulo2;
  const double heigthCeldastable = 30;
  final imageIcon = await loadImage('logo.png');

  final page = pw.Page(
    //orientation: pw.PageOrientation.landscape,
    pageFormat: PdfPageFormat.a4.copyWith(
      marginBottom: 0,
      marginLeft: 0,
      marginRight: 0,
      marginTop: 0,
    ),
    build: (pw.Context context) {
      return pw.Container(
        padding:
            const pw.EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Container(
                  height: 60,
                  width: 60,
                  color: const PdfColor.fromInt(0xFF051367),
                  child: pw.Image(
                    pw.MemoryImage(imageIcon),
                    fit: pw.BoxFit.contain,
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Container(
                  width: 200,
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    "DIPLOMA DE AUTORIZACIÓN PARA USO DE EQUIPOS MÓVILES",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 14),
                  ),
                ),
                pw.SizedBox(width: 30),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    userDetailEncabezado("Empresa:", "Minera Chinalco Peru"),
                    userDetailEncabezado("Fecha:", DateTime.now().toString()),
                    userDetailEncabezado(
                        "Proceso:", "Entrenamiento de equipos moviles"),
                  ],
                )
              ],
            ).padding(
              const pw.EdgeInsets.only(bottom: 10),
            ),
            pw.Container(
              width: double.infinity,
              alignment: pw.Alignment.centerLeft,
              child: pw.Text("Datos del operador autorizado",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                  .padding(const pw.EdgeInsets.only(bottom: 10, top: 20)),
            ),
            cardCustom(
              pw.Column(
                children: [
                  pw.Column(children: [
                    userDetail("Código MCP:", personal!.codigoMcp),
                    userDetail("Nombres y apellidos:", personal.nombreCompleto),
                    userDetail("Guardia:", personal.guardia!.nombre),
                  ]).padding(const pw.EdgeInsets.only(left: 20)),
                ],
              ),
            ),
            pw.Container(
              width: double.infinity,
              alignment: pw.Alignment.centerLeft,
              child: pw.Text("Datos del entrenamiento",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                  .padding(const pw.EdgeInsets.only(bottom: 10, top: 20)),
            ),
            cardCustom(
              pw.Column(children: [
                userDetail("Equipo móvil:", entrenamiento!.equipo!.nombre),
                userDetail("Condición:", entrenamiento.condicion!.nombre),
                userDetail("Entrenador responsable:",
                    entrenamiento.entrenador!.nombre),
              ]).padding(const pw.EdgeInsets.only(left: 20)),
            ),
            pw.SizedBox(height: 20),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FixedColumnWidth(100),
                  1: const pw.FixedColumnWidth(150),
                },
                children: [
                  pw.TableRow(
                    children: [
                      pw.Container(
                          height: heigthCeldastable,
                          alignment: pw.Alignment.center,
                          color: const PdfColor.fromInt(0xFF051367),
                          child: pw.Text("Módulo",
                              style:
                                  const pw.TextStyle(color: PdfColors.white))),
                      pw.Container(
                          height: heigthCeldastable,
                          alignment: pw.Alignment.center,
                          color: const PdfColor.fromInt(0xFF051367),
                          child: pw.Text("Horas",
                              style:
                                  const pw.TextStyle(color: PdfColors.white))),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Container(
                          height: heigthCeldastable,
                          alignment: pw.Alignment.center,
                          child: pw.Text("I")),
                      pw.Container(
                          height: heigthCeldastable,
                          alignment: pw.Alignment.center,
                          child: pw.Text("$horamodulo1")),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Container(
                          height: heigthCeldastable,
                          alignment: pw.Alignment.center,
                          child: pw.Text("II")),
                      pw.Container(
                          height: heigthCeldastable,
                          alignment: pw.Alignment.center,
                          child: pw.Text("$horamodulo2")),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Container(
                          height: heigthCeldastable,
                          alignment: pw.Alignment.center,
                          child: pw.Text("Total")),
                      pw.Container(
                          height: heigthCeldastable,
                          alignment: pw.Alignment.center,
                          child: pw.Text("$totalHoras")),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(width: 40),
              pw.Column(children: [
                userDetailEncabezado(
                    "Fecha inicio:",
                    DateFormat('dd/MM/yyyy')
                        .format(entrenamiento.fechaInicio!)),
                userDetailEncabezado(
                    "Fecha fin:",
                    DateFormat('dd/MM/yyyy')
                        .format(entrenamiento.fechaTermino!)),
              ])
            ]).padding(const pw.EdgeInsets.only(left: 60, right: 20)),
            pw.Container(
              width: double.infinity,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Objetivos",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                      .padding(const pw.EdgeInsets.only(top: 10, bottom: 10)),
                  pw.Text(
                      "- Verificar avance de operador en el desarrollo del plan de capacitación y entrenamiento en mensión."),
                  pw.Text(
                      "- Identificar las oportunidades de mejora del nuevo operador para su posterior monitoreo en operación del equipo."),
                ],
              ),
            ),
            pw.Container(
              width: double.infinity,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Metodología",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                      .padding(const pw.EdgeInsets.only(top: 10, bottom: 10)),
                  pw.Text(
                      "- El porcentaje mínimo aprobatorio es de 80%. Siendo el primer módulo pre-registro para el siguiente así sucesivamente."),
                ],
              ),
            ),
            pw.Container(
              width: double.infinity,
              alignment: pw.Alignment.centerLeft,
              child: pw.Text("Evaluación del participante")
                  .padding(const pw.EdgeInsets.only(top: 10, bottom: 10)),
            ),
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: const pw.FlexColumnWidth(2),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(1),
                3: const pw.FlexColumnWidth(1),
                4: const pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      height: heigthCeldastable,
                      alignment: pw.Alignment.center,
                      color: const PdfColor.fromInt(0xFF051367),
                      child: pw.Text("Notas",
                          style: const pw.TextStyle(color: PdfColors.white)),
                    ),
                    pw.Container(
                      height: heigthCeldastable,
                      alignment: pw.Alignment.center,
                      color: const PdfColor.fromInt(0xFF051367),
                      child: pw.Text("Módulo I",
                          style: const pw.TextStyle(color: PdfColors.white)),
                    ),
                    pw.Container(
                      height: heigthCeldastable,
                      alignment: pw.Alignment.center,
                      color: const PdfColor.fromInt(0xFF051367),
                      child: pw.Text("Módulo II",
                          style: const pw.TextStyle(color: PdfColors.white)),
                    ),
                    pw.Container(
                      height: heigthCeldastable,
                      alignment: pw.Alignment.center,
                      color: const PdfColor.fromInt(0xFF051367),
                      child: pw.Text("Módulo III",
                          style: const pw.TextStyle(color: PdfColors.white)),
                    ),
                    pw.Container(
                      height: heigthCeldastable,
                      alignment: pw.Alignment.center,
                      color: const PdfColor.fromInt(0xFF051367),
                      child: pw.Text("Módulo IV",
                          style: const pw.TextStyle(color: PdfColors.white)),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Text("Teórico"),
                    pw.Text("20"),
                    pw.Text("15"),
                    pw.Text("44"),
                    pw.Text("50"),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Text("Práctico"),
                    pw.Text("30"),
                    pw.Text("35"),
                    pw.Text("50"),
                    pw.Text("68"),
                  ],
                ),
              ],
            ),
            pw.Container(
              width: double.infinity,
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(
                      "Se concluye que el operador queda APTO para operar el equipo HEX 390DL")
                  .padding(const pw.EdgeInsets.only(top: 10, bottom: 10)),
            ),
          ],
        ),
      );
    },
  );
  return page;
}
