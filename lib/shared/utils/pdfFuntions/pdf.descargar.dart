import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfx/pdfx.dart';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:image/image.dart';

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
    orientation: pw.PageOrientation.portrait, // Ajusta según necesidades
    margin: const pw.EdgeInsets.all(10), // Reducir márgenes para usar espacio
    build: (pw.Context context) {
      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: List.generate(
          totalColumns,
          (index) {
            // Calcular posiciones de imágenes
            final int position1 = index * 2;
            final int position2 = position1 + 1;

            return _columnCarnet(images, position1, position2);
          },
        ),
      );
    },
  );
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

// Descargar múltiples páginas como PDF
Future<void> descargarPaginasComoPdf(List<PdfPageImage?> imagess,
    {String nombreArchivo = "documento.pdf", bool rotar = false}) async {
  if (imagess.isEmpty) {
    print("No hay imágenes para generar el PDF.");
    return;
  }

  final pdf = pw.Document();

  // Verifica si es una sola página
  if (imagess.length == 1) {
    final image = imagess.first;
    if (image != null) {
      final optimizedImage =
          rotar ? rotateImage(image.bytes) : compressImage(image.bytes);

      // Crea una página simple con una sola imagen
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(
                pw.MemoryImage(optimizedImage),
                fit: pw.BoxFit.contain,
              ),
            );
          },
        ),
      );
    }
  } else {
    // Si son múltiples imágenes, utiliza el GridView
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(10),
        build: (pw.Context context) {
          return pw.GridView(
            crossAxisCount: 2, // Dos columnas por página
            childAspectRatio: 1, // Proporción de las imágenes
            children: imagess.where((image) => image != null).map((image) {
              final optimizedImage = rotar
                  ? rotateImage(image!.bytes)
                  : compressImage(image!.bytes);

              return pw.Container(
                padding: const pw.EdgeInsets.all(5), // Espaciado entre imágenes
                child: pw.Image(
                  pw.MemoryImage(optimizedImage),
                  fit: pw.BoxFit.contain,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  // Guardar y descargar el archivo PDF
  final Uint8List bytes = await pdf.save();
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', nombreArchivo)
    ..click();
  html.Url.revokeObjectUrl(url);
}

// Comprimir una imagen con calidad ajustable
Uint8List compressImage(Uint8List imageBytes, {int quality = 70}) {
  final image = decodeImage(imageBytes);
  if (image != null) {
    final compressed = encodeJpg(image, quality: quality);
    return Uint8List.fromList(compressed);
  }
  return imageBytes;
}

// Redimensionar la imagen a un tamaño fijo
Uint8List resizeImage(Uint8List imageBytes, {int width = 600}) {
  final image = decodeImage(imageBytes);
  if (image != null) {
    final resized = copyResize(image, width: width);
    return Uint8List.fromList(encodeJpg(resized, quality: 70));
  }
  return imageBytes;
}

// Convertir imagen a escala de grises
// Convertir imagen a escala de grises
Uint8List convertToGrayscale(Uint8List imageBytes) {
  final decodedImage = decodeImage(imageBytes);
  if (decodedImage != null) {
    final grayImage = grayscale(decodedImage);
    return Uint8List.fromList(encodeJpg(grayImage, quality: 70));
  }
  return imageBytes;
}

// Rotar la imagen 90 grados si es necesario
Uint8List rotateImage(Uint8List imageBytes) {
  final image = decodeImage(imageBytes);
  if (image != null) {
    final rotated = copyRotate(image, angle: 90);
    return Uint8List.fromList(encodeJpg(rotated));
  }
  return imageBytes;
}

// Generar una columna dinámica para las imágenes
pw.Widget _columnCarnet(
    List<PdfPageImage?> images, int position1, int position2) {
  return pw.Column(
    mainAxisAlignment: pw.MainAxisAlignment.center,
    children: [
      pw.Expanded(
        child: (position1 < images.length && images[position1] != null)
            ? pw.Image(
                pw.MemoryImage(
                  resizeImage(images[position1]!.bytes, width: 800),
                ),
              )
            : pw.Container(), // Si no hay imagen, muestra contenedor vacío
      ),
      pw.Expanded(
        child: (position2 < images.length && images[position2] != null)
            ? pw.Image(
                pw.MemoryImage(
                  resizeImage(images[position2]!.bytes, width: 800),
                ),
              )
            : pw.Container(), // Si no hay imagen, muestra contenedor vacío
      ),
    ],
  );
}
