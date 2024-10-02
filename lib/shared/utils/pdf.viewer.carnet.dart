import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/utils/Extensions/widgetExtensions.dart';
import 'package:sgem/shared/utils/PDFGenerators/generate.autorizacion.operar.dart';
import 'package:sgem/shared/utils/PDFGenerators/generate.personal.carnet.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';
import 'package:sgem/shared/utils/pdfFuntions/prueba.dart';

class PdfToImageScreen extends StatefulWidget {
  final Personal? data;

  const PdfToImageScreen({super.key, required this.data});

  @override
  State<PdfToImageScreen> createState() => _PdfToImageScreenState();
}

class _PdfToImageScreenState extends State<PdfToImageScreen> {
  List<Future<pw.Page>> listPagues = [];
  Future<List<PdfPageImage?>> list = Future.value([]);

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final personalData = widget.data;
    if(personalData != null ) {
      listPagues.add(generatePersonalCarnetFrontPdf(personalData, 'credencial_verde_front_full.png'));
      listPagues.add(generatePersonalCarnetBackPdf(personalData, 'credencial_verde_front_full.png'));
      listPagues.add(generatePersonalCarnetFrontPdf(personalData, 'credencial_verde_front_full.png'));
      listPagues.add(generatePersonalCarnetBackPdf(personalData, 'credencial_verde_front_full.png'));
      listPagues.add(generatePersonalCarnetFrontPdf(personalData, 'credencial_amarillo_front_full.png'));
      listPagues.add(generatePersonalCarnetBackPdf(personalData, 'credencial_amarillo_front_full.png'));
      listPagues.add(generatePersonalCarnetFrontPdf(personalData, 'credencial_amarillo_front_full.png'));
      listPagues.add(generatePersonalCarnetBackPdf(personalData, 'credencial_amarillo_front_full.png'));
      setState(() {
        list = getImages(listPagues);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //final screenHeigth = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 500,
              child:
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: FutureBuilder(
                    future: getImages(listPagues), //<- crear imagen
                    builder: (context, AsyncSnapshot<List<PdfPageImage?>> snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        // Agrupamos las imágenes en pares
                        List<List<PdfPageImage?>> rows = [];
                        for (int i = 0; i < snapshot.data!.length; i += 2) {
                          rows.add(snapshot.data!.sublist(i, i + 2 > snapshot.data!.length ? snapshot.data!.length : i + 2));
                        }
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: rows.map((List<PdfPageImage?> row) {
                              return 
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: row.map((PdfPageImage? pageImage) => pageImage != null
                                        ? Image.memory(pageImage.bytes).padding(const EdgeInsets.all(10))
                                        : const SizedBox.shrink(),
                                    ).toList(),
                                  ).padding(const EdgeInsets.all(10));
                              // );
                            }).toList(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error al cargar el PDF: ${snapshot.error}'),
                        );
                      } else {
                        return const Center( child: CircularProgressIndicator());
                      } 
                    },
                  ),  
                )     
              ).padding(const EdgeInsets.only(bottom: 20)),
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
                  onPressed: (){
                      descargarPaginaComoPdf(list);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text("Imprimir", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
            const SizedBox(height: 20),
        ]
        ),
      ),
    );
  }
}

