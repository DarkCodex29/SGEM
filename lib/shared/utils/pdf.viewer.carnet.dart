import 'package:flutter/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/utils/PDFGenerators/generate.autorizacion.operar.dart';
import 'package:sgem/shared/utils/PDFGenerators/generate.personal.carnet.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.descargar.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';
import 'package:sgem/shared/utils/widgets/future.view.pdf.dart';
import '../../modules/pages/consulta.personal/consulta.personal.controller.dart';

class PdfToImageScreen extends StatefulWidget {
  final Personal? data;
  final PersonalSearchController controller;

  const PdfToImageScreen(
      {super.key, required this.data, required this.controller});

  @override
  State<PdfToImageScreen> createState() => _PdfToImageScreenState();
}

class _PdfToImageScreenState extends State<PdfToImageScreen> {
  Future<List<PdfPageImage?>>? _getdata;

  @override
  void initState() {
    super.initState();
    _getdata = getData();
  }

  Future<List<PdfPageImage?>> getData() async {
    final personalData = widget.data;
    List<Future<pw.Page>> listPages = [];
    if (personalData != null) {
      final photoPerfil = await widget.controller
          .loadPersonalPhoto(personalData.inPersonalOrigen!);

      // Autorización para operar
      listPages.add(generatePersonalCarnetFrontPdf(
          personalData, 'credencial_verde_front_full.png', photoPerfil));
      listPages.add(generatePersonalCarnetBackPdf(personalData,
          'credencial_verde_front_full.png', 'AUTORIZADO PARA OPERAR'));

      listPages.add(generatePersonalCarnetFrontPdf(
          personalData, 'credencial_verde_front_full.png', photoPerfil));
      listPages.add(generatePersonalCarnetBackPdf(personalData,
          'credencial_verde_front_full.png', 'AUTORIZADO PARA OPERAR'));

      // Autorización para entrenar
      listPages.add(generatePersonalCarnetFrontPdf(
          personalData, 'credencial_amarillo_full.png', photoPerfil));
      listPages.add(generatePersonalCarnetBackPdf(personalData,
          'credencial_amarillo_full.png', 'AUTORIZADO PARA ENTRENAR'));

      listPages.add(generatePersonalCarnetFrontPdf(
          personalData, 'credencial_amarillo_full.png', photoPerfil));
      listPages.add(generatePersonalCarnetBackPdf(personalData,
          'credencial_amarillo_full.png', 'AUTORIZADO PARA ENTRENAR'));

      return getImages(listPages);
    }
    return [];
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
    );
  }
}
