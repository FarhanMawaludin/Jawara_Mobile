import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// ✅ Import IuranDetail
import '../../../data/models/iurandetail_model.dart';

class TagihanPdfGenerator {
  static Future<void> printPDF(List<IuranDetail> iuranDetailList) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw. Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Text(
                'Daftar Tagihan Iuran',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),

              // Table
              pw.TableHelper.fromTextArray(
                headers: ['Nama', 'Kategori', 'Tanggal', 'Jumlah', 'Status'],
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
                cellStyle: const pw.TextStyle(fontSize: 10),
                headerDecoration: const pw. BoxDecoration(
                  color: PdfColors.grey300,
                ),
                cellAlignment:  pw.Alignment.centerLeft,
                data: iuranDetailList.map((item) {
                  // ✅ Akses data dari relasi tagihIuranData
                  final tagihan = item.tagihIuranData;
                  
                  return [
                    tagihan?.nama ?? '-',
                    tagihan?.kategoriId.toString() ?? '-',
                    tagihan?.tanggalTagihan != null
                        ?  '${tagihan!.tanggalTagihan.day}/${tagihan.tanggalTagihan. month}/${tagihan.tanggalTagihan.year}'
                        : '-',
                    'Rp ${_formatRupiah((tagihan?.jumlah ?? 0).toInt())}',
                    item.statusPembayaran,
                  ];
                }).toList(),
              ),

              pw.SizedBox(height: 20),

              // Footer
              pw.Text(
                'Total Tagihan:  ${iuranDetailList.length} item',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),

              pw. Text(
                'Total Nominal: Rp ${_formatRupiah(_calculateTotal(iuranDetailList))}',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );

    // Print or save PDF
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  // ✅ Helper untuk format rupiah
  static String _formatRupiah(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  // ✅ Helper untuk hitung total - DIPERBAIKI
  static int _calculateTotal(List<IuranDetail> list) {
    return list.fold<int>(
      0, 
      (sum, item) => sum + ((item.tagihIuranData?.jumlah ?? 0).toInt()), // ✅ UBAH:  tagihIuran → tagihIuranData
    );
  }
}