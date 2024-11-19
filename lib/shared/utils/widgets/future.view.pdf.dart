import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:sgem/config/theme/app_theme.dart';

class PdfViewer extends StatelessWidget {
  final Future<List<PdfPageImage?>>? futurePdf;
  final double angleRotation;
  final VoidCallback onCancel;
  final Function(List<PdfPageImage?>) onPrint;

  const PdfViewer({
    super.key,
    required this.futurePdf,
    required this.angleRotation,
    required this.onCancel,
    required this.onPrint,
  });

  List<List<PdfPageImage?>> _groupImagesInPairs(List<PdfPageImage?> images) {
    return List.generate(
      (images.length / 2).ceil(),
      (index) => images.sublist(
        index * 2,
        (index * 2 + 2).clamp(0, images.length),
      ),
    );
  }

  Widget _buildPdfPage(PdfPageImage? pageImage) {
    if (pageImage == null) return const SizedBox.shrink();

    const double scaleFactor = 0.9;

    return Center(
      child: Transform.rotate(
        angle: angleRotation,
        child: SizedBox(
          width: pageImage.width! * scaleFactor,
          height: pageImage.height! * scaleFactor,
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.memory(pageImage.bytes),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PdfPageImage?>>(
      future: futurePdf,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text("Generando vista previa del PDF..."),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error al cargar el PDF: ${snapshot.error}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => futurePdf,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Reintentar',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final rows = snapshot.data!.length == 1
            ? [snapshot.data!]
            : _groupImagesInPairs(snapshot.data!);

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: rows.map((row) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.map((page) {
                    return _buildPdfPage(page);
                  }).toList(),
                );
              }).toList(),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onCancel,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("Cancelar",
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => onPrint(snapshot.data!),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    backgroundColor: AppTheme.backgroundBlue,
                  ),
                  child: const Text("Imprimir",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
