import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

buildPrintableData(double pageHeight, double pageWidth, Uint8List image) =>
    pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Container(
          height: pageHeight * 0.6,
          width: pageWidth * 0.7,
          decoration: pw.BoxDecoration(
              boxShadow: const [
                pw.BoxShadow(
                  // color: Colors.grey.shade600,
                  color: PdfColor(0.458, 0.458, 0.458, 1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  // offset: Offset(0, 5),
                )
              ],
              color: const PdfColor(1, 1, 1, 1),
              borderRadius: pw.BorderRadius.circular(15)),
          child: pw.Column(
            children: [
              // final image = pw.MemoryImage(File('path_to_your_image.png').readAsBytesSync());
              pw.Image(pw.MemoryImage(image),
                  height: pageHeight * 0.7, width: pageWidth * 0.7),
              pw.SizedBox(
                height: 15,
              ),
              pw.Text(
                "Rally",
                style: pw.TextStyle(
                  font: pw.Font.courierBold(),
                  fontSize: 20,
                  color: const PdfColor(0, 0, 0),
                ),
              ),
              pw.SizedBox(
                height: 6,
              ),
              pw.Text(
                "Dayal Bagh, Agra",
                style: pw.TextStyle(
                  font: pw.Font.courierBold(),
                  fontSize: 16,
                  color: const PdfColor(0, 0, 0),
                ),
              ),
              // pw.Text(
              //   "- - - - - - - - - - - - - - - - - - - - - - - - - - ",
              //   style: const pw.TextStyle(
              //       fontSize: 25, color: PdfColor(0.619, 0.619, 0.619)),
              //   softWrap: false,
              // ),
              pw.Divider(color: PdfColor(0.619, 0.619, 0.619)),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 20.0),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "01/12/2023",
                      style: pw.TextStyle(
                        font: pw.Font.courierBold(),
                        fontSize: 16,
                        color: const PdfColor(0, 0, 0),
                      ),
                    ),
                    pw.Text(
                      "08:00 AM",
                      style: pw.TextStyle(
                        font: pw.Font.courierBold(),
                        fontSize: 16,
                        color: const PdfColor(0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(
                height: 5,
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 20.0),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Date",
                      style: pw.TextStyle(
                          font: pw.Font.courier(),
                          fontSize: 14,
                          color: const PdfColor(0.619, 0.619, 0.619)),
                    ),
                    pw.Text(
                      "Time",
                      style: pw.TextStyle(
                          font: pw.Font.courier(),
                          fontSize: 14,
                          color: const PdfColor(0.619, 0.619, 0.619)),
                    ),
                  ],
                ),
              ),
              pw.Divider(color: PdfColor(0.619, 0.619, 0.619)),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 20.0),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "PhonePay",
                      style: pw.TextStyle(
                        font: pw.Font.courierBold(),
                        fontSize: 16,
                        color: const PdfColor(0, 0, 0),
                      ),
                    ),
                    pw.Text(
                      "Rs. 400",
                      style: pw.TextStyle(
                        font: pw.Font.courierBold(),
                        fontSize: 16,
                        color: const PdfColor(0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(
                height: 5,
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 20.0),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Payment Method",
                      style: pw.TextStyle(
                          font: pw.Font.courier(),
                          fontSize: 14,
                          color: const PdfColor(0.619, 0.619, 0.619)),
                    ),
                    pw.Text(
                      "Price",
                      style: pw.TextStyle(
                          font: pw.Font.courier(),
                          fontSize: 14,
                          color: const PdfColor(0.619, 0.619, 0.619)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(
          height: 15,
        ),
        pw.Text(
          "Thanks for choosing EventScout!",
          style: pw.TextStyle(
              color: const PdfColor(0.619, 0.619, 0.619), fontSize: 12.00),
        ),
        pw.SizedBox(
          height: 4,
        ),
        pw.Text(
          "Contact 80774 XXXXX for any clarifications.",
          style: pw.TextStyle(
              color: const PdfColor(0.619, 0.619, 0.619), fontSize: 12.00),
        ),
        pw.SizedBox(
          height: 15,
        ),
      ],
    );
