import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/utils/PDFGenerators/generate.diploma.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.descargar.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';
import 'dart:math';
import 'package:sgem/shared/utils/widgets/future.view.pdf.dart';
import '../../modules/pages/consulta.personal/consulta.personal.controller.dart';

class PdfToDiplomaScreen extends StatefulWidget {
  final Personal? personal;
  final PersonalSearchController controller;
  const PdfToDiplomaScreen(
      {super.key, required this.personal, required this.controller});

  @override
  State<PdfToDiplomaScreen> createState() => _PdfToDiplomaScreenState();
}

class _PdfToDiplomaScreenState extends State<PdfToDiplomaScreen> {
  Future<List<PdfPageImage?>>? _getdata;

  @override
  void initState() {
    super.initState();
    _getdata = getData();
  }

  Future<List<PdfPageImage?>> getData() async {
    final personalData = widget.personal;
    List<Future<pw.Page>> listPages = [];
    listPages.add(generateDiploma(personalData!));
    return getImages(listPages);
  }

  @override
  Widget build(BuildContext context) {
    const angleRotacion = -pi / 2;

    return PdfViewer(
      futurePdf: _getdata,
      angleRotation: angleRotacion,
      onCancel: () {
        widget.controller.showTraining(widget.personal!);
      },
      onPrint: (pages) {
        descargarPaginasComoPdf(pages,
            nombreArchivo: 'DIPLOMA_${widget.personal!.codigoMcp}');
      },
    );
  }
}
