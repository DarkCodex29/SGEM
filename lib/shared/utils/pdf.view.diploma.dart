import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:sgem/shared/utils/Extensions/widgetExtensions.dart';
import 'package:sgem/shared/utils/PDFGenerators/generate.diploma.dart';
import 'package:sgem/shared/utils/pdfFuntions/pdf.functions.dart';
import 'dart:math';

import 'package:sgem/shared/utils/pdfFuntions/prueba.dart';

class PdfToDiplomaScreen extends StatefulWidget {

  const PdfToDiplomaScreen({super.key});

  @override
  State<PdfToDiplomaScreen> createState() => _PdfToDiplomaScreenState();
}

class _PdfToDiplomaScreenState extends State<PdfToDiplomaScreen> {
  List<Future<pw.Page>> listPagues = [];
  Future<List<PdfPageImage?>> list = Future.value([]);
  
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData () async {
    listPagues.add(generateDiploma(context));
    setState(() {
        list = getImages(listPagues);
      });
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeigth = MediaQuery.of(context).size.height;
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
                    future: getImage(generateDiploma(context), 1),
                    builder: (context, AsyncSnapshot<PdfPageImage?> snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        var image = snapshot.data!.bytes;
                          return Center(
                                child: Transform.rotate(
                              angle: -pi / 2, // Rota la imagen 0.5 radianes (~28.6 grados)
                              child: Image.memory(image),
                            ),
                          );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error al cargar el PDF: ${snapshot.error}'),
                        );
                      } else {
                        return const Center( child: CircularProgressIndicator());
                      }
                    }
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