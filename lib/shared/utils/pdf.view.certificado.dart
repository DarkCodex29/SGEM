import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:sgem/shared/utils/PDFGenerators/generate.certificado.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';
import 'package:sgem/shared/utils/widgets/future.view.pdf.dart';

class PdfToCertificadoScreen extends StatefulWidget {

  const PdfToCertificadoScreen({super.key});

  @override
  State<PdfToCertificadoScreen> createState() => _PdfToCertificadoScreenState();
}

class _PdfToCertificadoScreenState extends State<PdfToCertificadoScreen> {
  List<Future<pw.Page>> listPagues = [];
  Future<List<PdfPageImage?>> list = Future.value([]);
  Future<List<PdfPageImage?>>? _getdata;

  
  @override
  void initState() {
    super.initState();
    _getdata = getData();
  }

  Future<List<PdfPageImage?>> getData () async {
    listPagues.add(generateCertificado(context));
    return getImages(listPagues);
  }

  @override
  Widget build(BuildContext context) {
    return futureViewPdf(context, _getdata, 0);
  }
}
