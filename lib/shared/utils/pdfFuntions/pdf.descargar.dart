import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfx/pdfx.dart';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:image/image.dart';

// Procesar una imagen (opcionalmente rotar, redimensionar y/o comprimir)
Uint8List processImage(Uint8List imageBytes,
    {int? width, int quality = 100, bool rotate = false}) {
  final image = decodeImage(imageBytes);
  if (image == null) return imageBytes;

  Image processedImage = image;

  if (width != null) {
    processedImage = copyResize(processedImage, width: width);
  }

  if (rotate) {
    processedImage = copyRotate(processedImage, angle: 90);
  }

  return Uint8List.fromList(encodeJpg(processedImage, quality: quality));
}

// Convertir una imagen a escala de grises
Uint8List convertToGrayscale(Uint8List imageBytes) {
  final decodedImage = decodeImage(imageBytes);
  if (decodedImage != null) {
    final grayImage = grayscale(decodedImage);
    return Uint8List.fromList(encodeJpg(grayImage, quality: 100));
  }
  return imageBytes;
}

// Generar el PDF dinámicamente con imágenes distribuidas en filas y columnas
pw.Widget generateDynamicGrid(List<PdfPageImage?> images,
    {int columns = 2, int imageWidth = 800}) {
  final rows = (images.length / columns).ceil();

  return pw.Column(
    children: List.generate(rows, (rowIndex) {
      return pw.Row(
        children: List.generate(columns, (colIndex) {
          final imageIndex = rowIndex * columns + colIndex;

          if (imageIndex < images.length && images[imageIndex] != null) {
            return pw.Expanded(
              child: pw.Container(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Image(
                  pw.MemoryImage(processImage(images[imageIndex]!.bytes,
                      width: imageWidth)),
                  fit: pw.BoxFit.contain,
                ),
              ),
            );
          } else {
            return pw.Expanded(child: pw.Container()); // Espacio vacío
          }
        }),
      );
    }),
  );
}

// Descargar un PDF generado con una o más páginas
Future<void> descargarPaginasComoPdf(List<PdfPageImage?> imagess,
    {String nombreArchivo = "documento.pdf",
    bool rotar = false,
    int columns = 2,
    double margin = 10.0}) async {
  if (imagess.isEmpty) {
    throw Exception("No hay imágenes para generar el PDF.");
  }

  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(margin),
      build: (pw.Context context) {
        return generateDynamicGrid(imagess, columns: columns);
      },
    ),
  );

  // Guardar y descargar el PDF
  final Uint8List bytes = await pdf.save();
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', nombreArchivo)
    ..click();
  html.Url.revokeObjectUrl(url);
}

// Descargar una sola página como PDF
Future<void> descargarPaginaComoPdf(Future<List<PdfPageImage?>> imagess,
    {String nombreArchivo = "documento.pdf", bool rotar = false}) async {
  var images = await imagess;

  if (images.isEmpty) {
    print("No hay imágenes para generar el PDF.");
    return;
  }

  return descargarPaginasComoPdf(images,
      nombreArchivo: nombreArchivo, rotar: rotar);
}

// Generar una columna dinámica de carnets (dos imágenes por columna)
pw.Widget _columnCarnet(
    List<PdfPageImage?> images, int position1, int position2) {
  return pw.Column(
    mainAxisAlignment: pw.MainAxisAlignment.center,
    children: [
      pw.Expanded(
        child: (position1 < images.length && images[position1] != null)
            ? pw.Image(
                pw.MemoryImage(
                    processImage(images[position1]!.bytes, width: 800)),
              )
            : pw.Container(),
      ),
      pw.Expanded(
        child: (position2 < images.length && images[position2] != null)
            ? pw.Image(
                pw.MemoryImage(
                    processImage(images[position2]!.bytes, width: 800)),
              )
            : pw.Container(),
      ),
    ],
  );
}

// Método para generar una página del PDF desde imágenes
Future<pw.Page> generatePdfPageFromImages(
    Future<List<PdfPageImage?>> imagess) async {
  var images = await imagess;
  return generatePdfPagesFromImages(images);
}

// Método para generar varias páginas del PDF desde imágenes
Future<pw.Page> generatePdfPagesFromImages(List<PdfPageImage?> imagess) async {
  var images = imagess;

  // Calcular columnas dinámicamente (2 imágenes por columna)
  final int totalColumns = (images.length / 2).ceil();

  return pw.Page(
    orientation: pw.PageOrientation.portrait,
    margin: const pw.EdgeInsets.all(10),
    build: (pw.Context context) {
      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: List.generate(
          totalColumns,
          (index) {
            final int position1 = index * 2;
            final int position2 = position1 + 1;

            return _columnCarnet(images, position1, position2);
          },
        ),
      );
    },
  );
}
