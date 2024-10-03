import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:sgem/shared/utils/Extensions/pdf.extensions.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';

Future<pw.Page> generateCertificado() async {
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
          padding: const pw.EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          child: pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Container(
                    height: 80,
                    width: 80,
                    color: PdfColors.yellow,
                    child: pw.Image(
                    pw.MemoryImage(imageIcon),
                    fit: pw.BoxFit.contain,
                    )
                  ),
                  pw.SizedBox(width: 20),
                  pw.Container(
                    width: 200,
                    alignment: pw.Alignment.center,
                    child: 
                      pw.Text("AUTORIZACION PARA USO DE EQUIPOS MOVILES")
                  )
                ]
              ).padding(const pw.EdgeInsets.only(bottom: 10)),
              cardCustom(
                pw.Column(
                  children: [
                    userDetail("Empresa", "Minera Chinalco Peru"),
                    pw.SizedBox(height: 10),
                    userDetail("Fecha", "06-06-2024"),
                    pw.SizedBox(height: 10),
                    userDetail("Proceso", "Entrenamiento de equipos moviles"),
                  ],
                ).padding(const pw.EdgeInsets.only(left: 20))
              ),
              pw.Container(
                width: double.infinity,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text("Datos del entrenamiento").padding(const pw.EdgeInsets.only(bottom: 10, top: 10)),
              ),
              cardCustom(
                pw.Column(
                  children: [
                    pw.Column(
                      children: [
                        userDetail("Empresa", "Minera Chinalco Peru"),
                        userDetail("Fecha", "06-06-2024"),
                        userDetail("Proceso", "Entrenamiento de equipos moviles").padding(const pw.EdgeInsets.only(bottom: 10)),
                      ]
                    ).padding(const pw.EdgeInsets.only(left: 20)),
                    
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
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
                                  color: PdfColors.blueAccent100,
                                  child: pw.Text("modulo")
                                ),
                                pw.Container(
                                  height: heigthCeldastable,
                                  alignment: pw.Alignment.center,
                                  color: PdfColors.blueAccent100,
                                  child: pw.Text("Horas")
                                )
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Container(
                                  height: heigthCeldastable,
                                  alignment: pw.Alignment.center,
                                  child: pw.Text("I")
                                ),
                                pw.Container(
                                  height: heigthCeldastable,
                                  alignment: pw.Alignment.center,
                                  child: pw.Text("$horamodulo1")
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Container(
                                  height: heigthCeldastable,
                                  alignment: pw.Alignment.center,
                                  child: pw.Text("II")
                                ),
                                pw.Container(
                                  height: heigthCeldastable,
                                  alignment: pw.Alignment.center,
                                  child: pw.Text("$horamodulo2")
                                ),
                              ],
                            ),
                            pw.TableRow(
                              children: [
                                pw.Container(
                                  height: heigthCeldastable,
                                  alignment: pw.Alignment.center,
                                  child: pw.Text("Total")
                                ),
                                pw.Container(
                                  height: heigthCeldastable,
                                  alignment: pw.Alignment.center,
                                  child: pw.Text("$totalHoras")
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(width: 50),
                        pw.Column(
                          children: [
                            userDetail("Fecha inicio", "12-04-2024"),
                            userDetail("Fecha fin", "15-05-2024"),
                          ]
                        )
                      ]
                    ).padding(const pw.EdgeInsets.only(left: 20)),
                    pw.Container(
                      width: double.infinity,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text("Objetivos").padding(const pw.EdgeInsets.only(top: 10)),
                          pw.Text("- Verificar avance de operador en el desarrollo del plan de capacitación y entrenamiento en mensión."),
                          pw.Text("- Identificar las oportunidades de mejora del nuevo operador para su posterior monitoreo en operación del equipo."),
                        ]
                      )
                    )]
                )
              ),
              pw.Container(
                width: double.infinity,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text("Evaluación del participante").padding(const pw.EdgeInsets.all(10)),
              ),
              cardCustom(
                pw.Column(
                  children: [
                    pw.Container(
                      width: double.infinity,
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text("- El porcentaje minimo aprobatorio es de 50%. Siendo el primer modulo pre-registro para el siguiente  asi sucesivamente.").padding(const pw.EdgeInsets.only(top: 10, bottom: 10)),
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(),
                          columnWidths: {
                            0: const pw.FixedColumnWidth(100),
                            1: const pw.FixedColumnWidth(100),
                            2: const pw.FixedColumnWidth(100),
                            3: const pw.FixedColumnWidth(100),
                            4: const pw.FixedColumnWidth(100),
                          },
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Container(
                                    height: heigthCeldastable,
                                    alignment: pw.Alignment.center,
                                    color: PdfColors.blueAccent100,
                                    child: pw.Text("Codigo de Operador")
                            ),
                            pw.Container(
                                    height: heigthCeldastable,
                                    alignment: pw.Alignment.center,
                                    color: PdfColors.blueAccent100,
                                    child: pw.Text("Modulo I")
                            ),
                            pw.Container(
                                    height: heigthCeldastable,
                                    alignment: pw.Alignment.center,
                                    color: PdfColors.blueAccent100,
                                    child: pw.Text("Modulo II")
                            ),
                            pw.Container(
                                    height: heigthCeldastable,
                                    alignment: pw.Alignment.center,
                                    color: PdfColors.blueAccent100,
                                    child: pw.Text("Modulo III")
                            ),
                            pw.Container(
                                    height: heigthCeldastable,
                                    alignment: pw.Alignment.center,
                                    color: PdfColors.blueAccent100,
                                    child: pw.Text("Modulo IV")
                            ),
                          ]
                        ),
                        pw.TableRow(
                          children: [
                            pw.Container(
                                    height: heigthCeldastable,
                                    alignment: pw.Alignment.center,
                                    child: pw.Text("Teórico")
                            ),
                            pw.Container(
                                    height: heigthCeldastable,
                                    alignment: pw.Alignment.center,
                                    child: pw.Text("80")
                            ),
                          ]
                        ),
                        pw.TableRow(
                          children: [
                            pw.Container(
                                    height: heigthCeldastable,
                                    alignment: pw.Alignment.center,
                                    child: pw.Text("Práctivco")
                            ),
                            pw.Container(
                                    height: heigthCeldastable,
                                    alignment: pw.Alignment.center,
                                    child: pw.Text("85")
                            ),
                          ]
                        )
                      ]
                    ).padding(const pw.EdgeInsets.only(left: 20)),
                    pw.Container(
                      width: double.infinity,
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text("Se concluye que el operador queda APTO para operar el equipo HEX 390DL").padding(const pw.EdgeInsets.only(top: 10, bottom: 10)),
                    ),
                  ]
                )
              )
            ],
          )
        );
      }
  );
  return page;
}
