import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/utils/PDFGenerators/generate.certificado.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.descargar.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';
import 'package:sgem/shared/utils/widgets/future.view.pdf.dart';

import '../../modules/pages/consulta.personal/consulta.personal.controller.dart';

class PdfToCertificadoScreen extends StatefulWidget {
  final PersonalSearchController controller;
  final Personal? data;

  const PdfToCertificadoScreen(
      {super.key, required this.data, required this.controller});

  @override
  State<PdfToCertificadoScreen> createState() => _PdfToCertificadoScreenState();
}

class _PdfToCertificadoScreenState extends State<PdfToCertificadoScreen> {
  Future<List<PdfPageImage?>>? _getdata;

  @override
  void initState() {
    super.initState();
    _getdata = getData();
  }

  Future<List<PdfPageImage?>> getData() async {
    List<Future<pw.Page>> listPages = [];
    listPages.add(generateCertificado());
    return getImages(listPages);
  }

  @override
  Widget build(BuildContext context) {
    return PdfViewer(
      futurePdf: _getdata,
      angleRotation: 0,
      onCancel: () {
        widget.controller.hideForms();
      },
      onPrint: (pages) {
        descargarPaginasComoPdf(pages);
      },
      //scaleFactor: 0.7,
    );
  }
}
