import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../domain/entities/mutasi.dart';

class MutasiPdfGenerator {
  static Future<Uint8List> generatePDF(List<Mutasi> mutasiList) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Laporan Mutasi Keuangan',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),

              pw.TableHelper.fromTextArray(
                headers: ['Tanggal', 'Kategori', 'Jenis', 'Jumlah', 'Keterangan'],
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
                cellStyle: const pw.TextStyle(fontSize: 10),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                cellAlignment: pw.Alignment.centerLeft,
                data: mutasiList.map((item) {
                  return [
                    '${item.tanggal.day}/${item.tanggal.month}/${item.tanggal.year}',
                    item.kategori ?? "-",
                    item.jenis == MutasiType.pemasukan ? "Pemasukan" : "Pengeluaran",
                    "Rp ${_formatRupiah(item.jumlah.toInt())}",
                  ];
                }).toList(),
              ),

              pw.SizedBox(height: 20),

              pw.Text(
                "Total Transaksi: ${mutasiList.length}",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),

              pw.Text(
                "Total Nominal: Rp ${_formatRupiah(_calculateTotal(mutasiList))}",
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static String _formatRupiah(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  static int _calculateTotal(List<Mutasi> list) {
    return list.fold(0, (sum, item) => sum + item.jumlah.toInt());
  }
}
