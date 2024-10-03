import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sgem/shared/utils/PDFGenerators/generate.diploma.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';

class PDFGeneratoController extends GetxController {

  Rxn<List<PdfPageImage?>> certificate =  Rxn<List<PdfPageImage?>>();

  void getCertoficateImage(double screenWidth, double screenHeigth) async {
    List<Future<pw.Page>> listPagues = [];
    listPagues.add(generateDiploma());
    certificate.value = await getImages(listPagues);
  }

}