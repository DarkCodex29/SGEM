import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:sgem/shared/utils/PDFGenerators/generate.diploma.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';
import 'dart:math';
import 'package:sgem/shared/utils/widgets/future.view.pdf.dart';

import '../../modules/pages/consulta.personal/consulta.personal.controller.dart';

class PdfToDiplomaScreen extends StatefulWidget {

  final PersonalSearchController controller;
  const PdfToDiplomaScreen({super.key, required this.controller});

  @override
  State<PdfToDiplomaScreen> createState() => _PdfToDiplomaScreenState();
}

class _PdfToDiplomaScreenState extends State<PdfToDiplomaScreen> {
  List<Future<pw.Page>> listPagues = [];
  Future<List<PdfPageImage?>> list = Future.value([]);
  Future<List<PdfPageImage?>>? _getdata;
  
  @override
  void initState() {
    super.initState();
    _getdata = getData();
  }

  Future<List<PdfPageImage?>> getData () async {
    listPagues.add(generateDiploma());
    return getImages(listPagues,);
  }

  @override
  Widget build(BuildContext context) {
    var angleRotacion = -pi / 2;
    return futureViewPdf(context, _getdata, angleRotacion, widget.controller);
  }
}
