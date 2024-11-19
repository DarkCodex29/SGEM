import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/utils/PDFGenerators/generate.diploma.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';

class PDFGeneratoController extends GetxController {
  late final Personal? personalData;
  var certificate = <PdfPageImage?>[].obs;

  void getCertoficateImage() async {
    List<Future<pw.Page>> listPagues = [];
    listPagues.add(generateDiploma(personalData));
    certificate.value = await getImages(listPagues);
  }
}
