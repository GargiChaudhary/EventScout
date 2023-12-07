import 'package:events/model/printable_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';

class SavePdfButton extends StatelessWidget {
  final String image;
  const SavePdfButton({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(MediaQuery.of(context).size.width * 0.6, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: () => printDoc(MediaQuery.of(context).size.height,
          MediaQuery.of(context).size.width),
      child: const Text(
        "Save as PDF",
        style: TextStyle(color: Colors.white, fontSize: 20.00),
      ),
    );
  }

  Future<void> printDoc(pageHeight, pageWidth) async {
    final doc = pw.Document();
    final response = await http.get(Uri.parse(image));

    if (response.statusCode == 200) {
      final Uint8List imageData = response.bodyBytes;

      doc.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return buildPrintableData(pageHeight, pageWidth, imageData);
          }));
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => doc.save());
    } else {
      print("Gargi error of response code0");
    }
  }
}
