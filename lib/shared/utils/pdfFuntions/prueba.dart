import 'package:pdf/widgets.dart' as pw;
import 'package:pdfx/pdfx.dart';
import 'dart:typed_data';
import 'dart:html' as html;

Future<pw.Page> generatePdfPageFromImages(Future<List<PdfPageImage?>> imagess) async {
  var images = await imagess;
  // Crea la página del PDF
  return pw.Page(
    orientation: pw.PageOrientation.landscape,
    build: (pw.Context context) {
      return pw.Row(
        children: [
          _columnCarnet(images, 0, 4),
          _columnCarnet(images, 1, 5),
          _columnCarnet(images, 2, 6),
          _columnCarnet(images, 3, 7),
        ],
      );
    },
  );
}

Future<void> descargarPaginaComoPdf(Future<List<PdfPageImage?>> imagess) async {
  var page = await generatePdfPageFromImages(imagess);
  // Crea un documento PDF
  final pdf = pw.Document();

  // Agrega la página al documento
  pdf.addPage(page);

  // Genera el archivo PDF como Uint8List
  final Uint8List bytes = await pdf.save();

  // Crea un blob a partir del archivo PDF
  final blob = html.Blob([bytes], 'application/pdf');

  // Crea una URL para el archivo PDF
  final url = html.Url.createObjectUrlFromBlob(blob);

  // Crea un enlace temporal para la descarga
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', 'pagina.pdf')
    ..click();

  // Revoca la URL temporal
  html.Url.revokeObjectUrl(url);
}

pw.Widget _columnCarnet(List<PdfPageImage?> images, int position1, int position2) {
  return pw.Column(
    children: [
      // Mostrar las últimas dos imágenes
      pw.Expanded(
        child: images[position1] != null
            ? pw.Image(pw.MemoryImage(images[position1]!.bytes))
            : pw.Container(), // Si es null, muestra un contenedor vacío
      ),
      pw.Expanded(
        child: images[position2] != null
            ? pw.Image(pw.MemoryImage(images[position2]!.bytes))
            : pw.Container(), // Si es null, muestra un contenedor vacío
      ),
    ],
  );
}
