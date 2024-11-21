import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:sgem/modules/pages/consulta.personal/entrenamiento/entrenamiento.personal.controller.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/utils/PDFGenerators/generate.certificado.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.descargar.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';
import 'package:sgem/shared/utils/widgets/future.view.pdf.dart';
import '../../modules/pages/consulta.personal/consulta.personal.controller.dart';

class PdfToCertificadoScreen extends StatefulWidget {
  final PersonalSearchController controller;
  final Personal? personal;

  const PdfToCertificadoScreen(
      {super.key, required this.personal, required this.controller});

  @override
  State<PdfToCertificadoScreen> createState() => _PdfToCertificadoScreenState();
}

class _PdfToCertificadoScreenState extends State<PdfToCertificadoScreen> {
  Future<List<PdfPageImage?>>? _getdata;
  final EntrenamientoPersonalController entrenamientoController =
      Get.find<EntrenamientoPersonalController>();
  @override
  void initState() {
    super.initState();
    _getdata = getData();
  }

  Future<List<PdfPageImage?>> getData() async {
    final personalData = widget.personal;
    final training = entrenamientoController.selectedTraining.value;
    final modulos = entrenamientoController.modulosPorEntrenamiento;

    List<Future<pw.Page>> listPages = [];
    listPages.add(generateCertificado(personalData, training, modulos));
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
        descargarPaginasComoPdf(pages,
            nombreArchivo: 'CERTIFICADO_${widget.personal!.codigoMcp}');
      },
    );
  }
}
