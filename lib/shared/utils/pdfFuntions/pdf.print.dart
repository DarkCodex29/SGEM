import 'dart:typed_data';
import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;

Future<void> imprimirPDF(List<Future<pw.Page>> pages) async {
  final pdf = pw.Document();

  for (var futurePage in pages) {
    final page = await futurePage;
    pdf.addPage(page);
  }

  try {
    // Generar el archivo PDF en un Uint8List
    final Uint8List bytes = await pdf.save();

    // Crear un blob para descargar el PDF en Flutter Web
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Crear un enlace temporal para descargar el archivo
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "documento.pdf")
      ..click();

    // Liberar la URL creada
    html.Url.revokeObjectUrl(url);
  } catch (e) {
    print('Error al generar el PDF: $e');
  }
}