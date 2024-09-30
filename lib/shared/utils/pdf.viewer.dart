import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:sgem/modules/pages/personal%20training/personal/new.personal.controller.dart';
import 'package:sgem/shared/utils/PDFGenerators/generate.autorizacion.operar.dart';
import 'package:sgem/shared/utils/PDFGenerators/generate.personal.carnet.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';

class PdfToImageScreen extends StatefulWidget {
  const PdfToImageScreen({super.key});

  @override
  State<PdfToImageScreen> createState() => _PdfToImageScreenState();
}

class _PdfToImageScreenState extends State<PdfToImageScreen> {
  List<Future<pw.Page>> listPagues = [];
  final NewPersonalController controller = NewPersonalController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await controller.buscarPersonalPorId("1");
    if(controller.personalData != null ) {
      listPagues.add(generatePersonalCarnetFrontPdf(controller.personalData, 'assets/images/fondo_credencial.png'));
      listPagues.add(generatePersonalCarnetBackPdf(controller.personalData, 'assets/images/fondo_credencial.png'));
      listPagues.add(generatePersonalCarnetFrontPdf(controller.personalData, 'assets/images/fondo_credencial.png'));
      listPagues.add(generatePersonalCarnetBackPdf(controller.personalData, 'assets/images/fondo_credencial.png'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualización del carnet')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                future: getImage(listPagues), //<- crear imagen
                builder: (context, AsyncSnapshot<List<PdfPageImage?>> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    // Agrupamos las imágenes en pares
                    List<List<PdfPageImage?>> rows = [];
                    for (int i = 0; i < snapshot.data!.length; i += 2) {
                      rows.add(snapshot.data!.sublist(i, i + 2 > snapshot.data!.length ? snapshot.data!.length : i + 2));
                    }
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: rows.map((List<PdfPageImage?> row) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: row.map((PdfPageImage? pageImage) => pageImage != null
                                    ? Image.memory(pageImage.bytes)
                                    : const SizedBox.shrink(),
                                ).toList(),
                              ),
                              const SizedBox(height: 15),
                            ],
                          );
                          
                        }).toList(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error al cargar el PDF: ${snapshot.error}'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text("Cancelar", style: TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () => downloadPdf(listPagues),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text("Imprimir", style: TextStyle(color: Colors.white)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

