import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';

Future<pw.Page> generateDiploma() async {
  final image = await loadImage('diploma_full.png');
  final dimensionsImage = await getImageDimensions(image);
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
          child: 
          pw.Stack(
            children: [
              pw.Image(pw.MemoryImage(image)),
              pw.Row(
                children: [
                  pw.Spacer(),
                  pw.Container(
                    padding: const pw.EdgeInsets.only(left: 80),
                    child: pw.Column(
                      children: [
                        pw.SizedBox(height: dimensionsImage.height / 3.1),
                        pw.Text(
                          "Meza Perez Moises Brusle",
                          style: const pw.TextStyle(
                            fontSize: 20
                          )),
                        pw.SizedBox(height: dimensionsImage.height / 14),
                        pw.Text("Camion minero 980 E-S Leomosto",
                          style: const pw.TextStyle(
                              fontSize: 20
                            )),
                        pw.SizedBox(height: dimensionsImage.height / 16),
                        pw.Container(
                          padding: const pw.EdgeInsets.only(left: 60),
                          alignment: pw.Alignment.center,
                          width: 500,
                          child: pw.Column(
                            children: [
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                                children: [
                                  textFirma("SUPERINTENDENCIA OPERACIONES MINA"),
                                  textFirma("SUPERINTENDENCIA OPERACIONES MINA")
                                ]
                              ),
                              pw.SizedBox(height: dimensionsImage.height / 40),
                              textFirma("SUPERINTENDENCIA OPERACIONES MINA"),  
                            ]
                          )
                        ),
                      ]
                    )
                  )
                ]
              )
            ]
          )
        );
      }
  );
  return page;
}