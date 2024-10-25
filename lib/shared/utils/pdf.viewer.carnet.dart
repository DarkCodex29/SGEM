import 'package:flutter/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:sgem/modules/pages/personal.training/consulta.personal.controller.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/utils/PDFGenerators/generate.autorizacion.operar.dart';
import 'package:sgem/shared/utils/PDFGenerators/generate.personal.carnet.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';
import 'package:sgem/shared/utils/widgets/future.view.pdf.dart';

class PdfToImageScreen extends StatefulWidget {
  final Personal? data;
  final PersonalSearchController controller;

  const PdfToImageScreen({
    super.key,
    required this.data,
    required this.controller
    });

  @override
  State<PdfToImageScreen> createState() => _PdfToImageScreenState();
}

class _PdfToImageScreenState extends State<PdfToImageScreen> {
  Future<List<PdfPageImage?>>? _getdata;
  void oncancel;

  @override
  void initState() {
    super.initState();
    _getdata = getData();
  }

  Future<List<PdfPageImage?>> getData() async {
    final personalData = widget.data;
    List<Future<pw.Page>> listPagues = [];
    if(personalData != null) {
      final photoPerfil = await widget.controller.loadPersonalPhoto(personalData.inPersonalOrigen);
      listPagues.add(generatePersonalCarnetFrontPdf(personalData, 'credencial_verde_front_full.png', photoPerfil));
      listPagues.add(generatePersonalCarnetBackPdf(personalData, 'credencial_verde_front_full.png'));
      listPagues.add(generatePersonalCarnetFrontPdf(personalData, 'credencial_verde_front_full.png', photoPerfil));
      listPagues.add(generatePersonalCarnetBackPdf(personalData, 'credencial_verde_front_full.png'));
      listPagues.add(generatePersonalCarnetFrontPdf(personalData, 'credencial_amarillo_full.png', photoPerfil));
      listPagues.add(generatePersonalCarnetBackPdf(personalData, 'credencial_amarillo_full.png'));
      listPagues.add(generatePersonalCarnetFrontPdf(personalData, 'credencial_amarillo_full.png', photoPerfil));
      listPagues.add(generatePersonalCarnetBackPdf(personalData, 'credencial_amarillo_full.png'));
       return  getImages(listPagues);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return  futureViewPdf(context, _getdata, 0, widget.controller);
  }
}
