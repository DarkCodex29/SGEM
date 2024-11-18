import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfx/pdfx.dart' as pdf;
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

Future<Uint8List> _generatePdfAndConvertToImages(
    List<Future<pw.Page>> pages) async {
  final pdf = pw.Document();
  final resolvedPages = await Future.wait(pages);
  for (var page in resolvedPages) {
    pdf.addPage(page);
  }

  final pdfData = await pdf.save();
  return pdfData;
}

// Future<Uint8List> _generatePdfAndConvertToImage(Future<pw.Page> page) async {
//   final pdf = pw.Document();
//   final futurePage = await page;
//   pdf.addPage(futurePage);

//   final pdfData = await pdf.save();
//   return pdfData;
// }

Future<List<pdf.PdfPageImage?>> getImages(List<Future<pw.Page>> pages) async {
  List<pdf.PdfPageImage?> listaImagens = [];
  final document =
      await pdf.PdfDocument.openData(_generatePdfAndConvertToImages(pages));
  final totalPages = document.pagesCount;

  for (int i = 1; totalPages >= i; i++) {
    var size = 1.6;
    final page = await document.getPage(i);
    final image = await page.render(
      width: page.width / size,
      height: page.height / size,
      format: pdf.PdfPageImageFormat.jpeg,
      backgroundColor: '#ffffff',
    );
    listaImagens.add(image);
  }
  return listaImagens;
}

Future<pdf.PdfPageImage?> getImage(Future<pw.Page> page, double size) async {
  final document = await pdf.PdfDocument.openAsset("pdf/pagina.pdf");
  final futurePage = await document.getPage(1);
  final image = await futurePage.render(
    width: futurePage.width * size,
    height: futurePage.height * size,
    format: pdf.PdfPageImageFormat.jpeg,
    backgroundColor: '#ffffff',
  );
  return image;
}

Future<Uint8List> loadImage(String path) async {
  final ByteData data = await rootBundle.load('assets/images/$path');
  return data.buffer.asUint8List();
}

Future<Uint8List> loadImageSVG(BuildContext context, String path) async {
  final ByteData data = await SvgPicture.asset(
    'assets/images/$path',
    colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
  ).bytesLoader.loadBytes(context);

  return data.buffer.asUint8List();
}

pw.Widget userFirm(String label) {
  return pw.Column(children: [
    pw.SizedBox(
      width: 150,
      child: pw.Divider(color: PdfColors.black),
    ),
    pw.Container(
        width: 150, child: pw.Text(label, textAlign: pw.TextAlign.center))
  ]);
}

Future<pw.MemoryImage> generatePdfWithSvg2(
    String path, double width, double height) async {
  String svgString = await rootBundle.loadString('assets/images/$path');
  final PictureInfo pictureInfo =
      await vg.loadPicture(SvgStringLoader(svgString), null);
  final ui.Image image =
      await pictureInfo.picture.toImage(width.toInt(), height.toInt());
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) {
    throw Exception('Failed to convert image to ByteData');
  }
  final Uint8List pngBytes = byteData.buffer.asUint8List();
  final imageMemory = pw.MemoryImage(pngBytes);
  return imageMemory;
}

pw.Widget textFirma(String text) {
  return pw.Container(width: 150, child: pw.Text(text));
}

Future<ui.Image> getImageDimensions(Uint8List fondoImageBytes) async {
  ui.Image image = await _loadImage(fondoImageBytes);
  return image;
}

Future<ui.Image> _loadImage(Uint8List bytes) async {
  final Completer<ui.Image> completer = Completer();
  ui.decodeImageFromList(bytes, (ui.Image img) {
    completer.complete(img);
  });
  return completer.future;
}

pw.Widget cardCustom(pw.Widget childCustom) {
  return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: childCustom);
}

pw.Widget userDetail(String label, String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.SizedBox(
            width: 120,
            child: pw.Text(label,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 18))),
        pw.Text(": $value"),
      ],
    ),
  );
}
