import 'dart:async';
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
    List<EntrenamientoModulo> modulos) async {
  const double heigthCeldastable = 30;
  int totalHoras =
      modulos.fold(0, (sum, modulo) => sum + (modulo.inHorasAcumuladas ?? 0));
  final imageIcon = await loadImage('logo.png');
  modulos.sort((a, b) {
    return a.modulo!.nombre!.compareTo(b.modulo!.nombre!);
  });

  List<Map<String, dynamic>> notasPorCategoria(
      List<EntrenamientoModulo> modulos) {
    // Ordenar los módulos por nombre
    modulos.sort((a, b) => a.modulo!.nombre!.compareTo(b.modulo!.nombre!));

    // Crear las filas de categorías (Teórico y Práctico)
    return [
      {
        "tipo": "Teórico",
        "notas": modulos.map((modulo) => modulo.inNotaTeorica ?? 0).toList(),
      },
      {
        "tipo": "Práctico",
        "notas": modulos.map((modulo) => modulo.inNotaPractica ?? 0).toList(),
      },
    ];
  }

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
                    userDetailEncabezado("Fecha:",
                        DateFormat('dd/MM/yyyy').format(DateTime.now())),
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
                  ...modulos.map((modulo) {
                    return pw.TableRow(
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(0),
                          height: heigthCeldastable,
                          alignment: pw.Alignment.center,
                          child: pw.Text(modulo.modulo!.nombre!),
                        ),
                        pw.Container(
                            height: heigthCeldastable,
                            alignment: pw.Alignment.center,
                            child:
                                pw.Text(modulo.inHorasAcumuladas!.toString())),
                      ],
                    );
                  }),
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
              child: pw.Text("Evaluación del participante",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                  .padding(const pw.EdgeInsets.only(top: 10, bottom: 10)),
            ),
            pw.Table(
              border: pw.TableBorder.all(),
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
                    ...modulos.map((modulo) {
                      return pw.Container(
                        height: heigthCeldastable,
                        alignment: pw.Alignment.center,
                        color: const PdfColor.fromInt(0xFF051367),
                        child: pw.Text(modulo.modulo!.nombre!,
                            style: const pw.TextStyle(color: PdfColors.white)),
                      );
                    }),
                  ],
                ),
                ...notasPorCategoria(modulos).map((categoria) {
                  return pw.TableRow(
                    children: [
                      pw.Container(
                        height: heigthCeldastable,
                        alignment: pw.Alignment.center,
                        child: pw.Text(categoria["tipo"]),
                      ),
                      ...categoria["notas"].map((nota) {
                        return pw.Container(
                          height: heigthCeldastable,
                          alignment: pw.Alignment.center,
                          child: pw.Text(nota.toString()),
                        );
                      }).toList(),
                    ],
                  );
                }),
              ],
            ),
            pw.Container(
              width: double.infinity,
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(
                "Se concluye que el operador queda APTO para operar el equipo ${entrenamiento.equipo!.nombre} en la mina de Chinalco Perú.",
              ).padding(const pw.EdgeInsets.only(top: 10, bottom: 10)),
            ),
          ],
        ),
      );
    },
  );
  return page;
}
