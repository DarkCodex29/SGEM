import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfx/pdfx.dart';
import 'dart:html' as html;

void downloadPdf(List<Future<pw.Page>> pages) async {
  var pdfBytes = await _generatePdfAndConvertToImages(pages);
  final blob = html.Blob([pdfBytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute("download", "documento.pdf")
    ..click();
  html.Url.revokeObjectUrl(url);
}

Future<Uint8List> _generatePdfAndConvertToImages(List<Future<pw.Page>> pages) async {
  final pdf = pw.Document();
  final resolvedPages = await Future.wait(pages);
  for (var page in resolvedPages) {
    pdf.addPage(page);
  }

  final pdfData = await pdf.save();
  return pdfData;
}

Future<List<PdfPageImage?>> getImage(List<Future<pw.Page>> pages) async {
  List<PdfPageImage?> listaImagens = [];
  final document =await PdfDocument.openData(_generatePdfAndConvertToImages(pages));
  final totalPages = document.pagesCount;
  for(int i = 1; totalPages >= i; i++) {
    var size = 1.6;
    final page = await document.getPage(i);
    final image = await page.render(
      width: page.width / size,
      height: page.height / size,
      format: PdfPageImageFormat.jpeg,
      backgroundColor: '#ffffff',
    );
    listaImagens.add(image);
  }
  return listaImagens;
}