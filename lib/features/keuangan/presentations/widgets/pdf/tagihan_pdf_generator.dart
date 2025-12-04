import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../domain/entities/tagihiuran.dart';

class TagihanPdfGenerator {
  static Future<void> printPDF(List<TagihIuran> data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(20),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Laporan Tagihan",
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),

              pw.Table.fromTextArray(
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
                cellStyle: const pw.TextStyle(fontSize: 9),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFEFEFEF),
                ),
                border: pw.TableBorder.all(color: PdfColor.fromInt(0xFFCCCCCC)),
                headers: [
                  "No",
                  "Nama Keluarga",
                  "Kategori",
                  "ID Tagihan",
                  "Nominal",
                  "Tanggal Tagihan",
                  "Status",
                ],
                data: List.generate(data.length, (index) {
                  final item = data[index];

                  return [
                    (index + 1).toString(),
                    item.nama,
                    item.kategoriId,
                    "TG${item.id.toString().padLeft(8, '0')}",
                    "Rp ${item.jumlah.toStringAsFixed(0)}",
                    "${item.tanggalTagihan.day} "
                        "${_bulan(item.tanggalTagihan.month)} "
                        "${item.tanggalTagihan.year}",
                    item.statusTagihan,
                  ];
                }),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  // Fungsi bantu format bulan
  static String _bulan(int bulan) {
    const bulanList = [
      "",
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];
    return bulanList[bulan];
  }
}
