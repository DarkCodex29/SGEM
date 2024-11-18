import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

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
    List<List<PdfPageImage?>> rows = [];
    for (int i = 0; i < images.length; i += 2) {
      final range = i + 2 > images.length ? images.length : i + 2;
      rows.add(images.sublist(i, range));
    }
    return rows;
  }

  Widget _buildPdfPage(PdfPageImage? pageImage) {
    if (pageImage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Transform.rotate(
          angle: angleRotation,
          child: Image.memory(pageImage.bytes),
        ),
      ),
    );
  }

  Widget _buildActionButtons(List<PdfPageImage?> pages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onCancel,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            backgroundColor: Colors.white,
          ),
          child: const Text("Cancelar", style: TextStyle(color: Colors.black)),
        ),
        const SizedBox(width: 15),
        ElevatedButton(
          onPressed: () => onPrint(pages),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            backgroundColor: Colors.blue,
          ),
          child: const Text("Imprimir", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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

        final rows = _groupImagesInPairs(snapshot.data!);

        return Column(
          children: [
            SizedBox(
              height: screenHeight * 0.75,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: rows.map((row) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: row.map((page) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: _buildPdfPage(page),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            _buildActionButtons(snapshot.data!),
          ],
        );
      },
    );
  }
}
