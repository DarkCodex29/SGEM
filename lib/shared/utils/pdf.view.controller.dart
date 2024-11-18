import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sgem/shared/utils/PDFGenerators/generate.diploma.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';

class PDFGeneratoController extends GetxController {
  var certificate = <PdfPageImage?>[].obs;

  void getCertoficateImage() async {
    List<Future<pw.Page>> listPagues = [];
    listPagues.add(generateDiploma());
    certificate.value = await getImages(listPagues);
  }
}