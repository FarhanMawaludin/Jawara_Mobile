import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../domain/entities/mutasi.dart';
import '../../providers/mutasi/mutasi_providers.dart';
import '../../widgets/pdf/mutasi_pdf_generator.dart';

class CetakLaporanMutasiPage extends ConsumerStatefulWidget {
  const CetakLaporanMutasiPage({super.key});

  @override
  ConsumerState<CetakLaporanMutasiPage> createState() => _CetakLaporanMutasiPageState();
}

class _CetakLaporanMutasiPageState extends ConsumerState<CetakLaporanMutasiPage> {
  // Filter states
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  String _selectedJenis = 'Semua'; // Semua, Pemasukan, Pengeluaran
  String? _selectedKategori;
  bool _isInitialized = false;
  
  // Format tanpa locale Indonesia
  final _formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  
  // Akan diinisialisasi setelah locale ready
  late DateFormat _formatDate;
  late DateFormat _formatMonth;

  @override
  void initState() {
    super.initState();
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    await initializeDateFormatting('id_ID', null);
    setState(() {
      _formatDate = DateFormat('dd MMM yyyy', 'id_ID');
      _formatMonth = DateFormat('MMMM yyyy', 'id_ID');
      _isInitialized = true;
    });
  }

  List<Mutasi> _filterTransaksi(List<Mutasi> transaksiList) {
    return transaksiList.where((transaksi) {
      // Filter bulan dan tahun
      if (transaksi.tanggal.month != _selectedMonth || 
          transaksi.tanggal.year != _selectedYear) {
        return false;
      }

      // Filter jenis
      if (_selectedJenis == 'Pemasukan' && transaksi.jenis != MutasiType.pemasukan) {
        return false;
      }
      if (_selectedJenis == 'Pengeluaran' && transaksi.jenis != MutasiType.pengeluaran) {
        return false;
      }

      // Filter kategori
      if (_selectedKategori != null && transaksi.kategori != _selectedKategori) {
        return false;
      }

      return true;
    }).toList()..sort((a, b) => a.tanggal.compareTo(b.tanggal));
  }

  Future<void> _generatePDF(List<Mutasi> transaksiList) async {
    final pdf = pw.Document();
    
    final filteredList = _filterTransaksi(transaksiList);
    
    // Hitung total
    double totalPemasukan = 0;
    double totalPengeluaran = 0;
    
    // Group by kategori
    final Map<String, double> kategoriPemasukan = {};
    final Map<String, double> kategoriPengeluaran = {};
    
    for (var transaksi in filteredList) {
      if (transaksi.jenis == MutasiType.pemasukan) {
        totalPemasukan += transaksi.jumlah;
        final kat = transaksi.kategori ?? 'Lainnya';
        kategoriPemasukan[kat] = (kategoriPemasukan[kat] ?? 0) + transaksi.jumlah;
      } else {
        totalPengeluaran += transaksi.jumlah;
        final kat = transaksi.kategori ?? 'Lainnya';
        kategoriPengeluaran[kat] = (kategoriPengeluaran[kat] ?? 0) + transaksi.jumlah;
      }
    }
    
    final saldo = totalPemasukan - totalPengeluaran;
    final periodeText = _formatMonth.format(DateTime(_selectedYear, _selectedMonth));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Header
          pw.Header(
            level: 0,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'LAPORAN MUTASI KEUANGAN',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Periode: $periodeText',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                if (_selectedJenis != 'Semua')
                  pw.Text(
                    'Jenis: $_selectedJenis',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                if (_selectedKategori != null)
                  pw.Text(
                    'Kategori: $_selectedKategori',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                pw.Text(
                  'Dicetak: ${DateFormat('dd MMMM yyyy HH:mm', 'id_ID').format(DateTime.now())}',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                ),
                pw.Divider(thickness: 2),
              ],
            ),
          ),
          
          // Ringkasan Total
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue50,
              border: pw.Border.all(color: PdfColors.blue200),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'RINGKASAN',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Pemasukan:'),
                    pw.Text(
                      _formatCurrency.format(totalPemasukan),
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green700,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Pengeluaran:'),
                    pw.Text(
                      _formatCurrency.format(totalPengeluaran),
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.red700,
                      ),
                    ),
                  ],
                ),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Saldo:',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      _formatCurrency.format(saldo),
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: saldo >= 0 ? PdfColors.green700 : PdfColors.red700,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Total ${filteredList.length} transaksi',
                  style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                ),
              ],
            ),
          ),
          
          pw.SizedBox(height: 20),
          
          // Ringkasan Per Kategori
          if (_selectedJenis != 'Pengeluaran' && kategoriPemasukan.isNotEmpty) ...[
            pw.Text(
              'PEMASUKAN PER KATEGORI',
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.green50),
                  children: [
                    _buildTableCell('Kategori', isHeader: true),
                    _buildTableCell('Jumlah', isHeader: true, align: pw.TextAlign.right),
                    _buildTableCell('Persentase', isHeader: true, align: pw.TextAlign.right),
                  ],
                ),
                ...kategoriPemasukan.entries.map((entry) {
                  final persentase = (entry.value / totalPemasukan * 100).toStringAsFixed(1);
                  return pw.TableRow(
                    children: [
                      _buildTableCell(entry.key),
                      _buildTableCell(
                        _formatCurrency.format(entry.value),
                        align: pw.TextAlign.right,
                      ),
                      _buildTableCell(
                        '$persentase%',
                        align: pw.TextAlign.right,
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
            pw.SizedBox(height: 16),
          ],
          
          if (_selectedJenis != 'Pemasukan' && kategoriPengeluaran.isNotEmpty) ...[
            pw.Text(
              'PENGELUARAN PER KATEGORI',
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.red50),
                  children: [
                    _buildTableCell('Kategori', isHeader: true),
                    _buildTableCell('Jumlah', isHeader: true, align: pw.TextAlign.right),
                    _buildTableCell('Persentase', isHeader: true, align: pw.TextAlign.right),
                  ],
                ),
                ...kategoriPengeluaran.entries.map((entry) {
                  final persentase = (entry.value / totalPengeluaran * 100).toStringAsFixed(1);
                  return pw.TableRow(
                    children: [
                      _buildTableCell(entry.key),
                      _buildTableCell(
                        _formatCurrency.format(entry.value),
                        align: pw.TextAlign.right,
                      ),
                      _buildTableCell(
                        '$persentase%',
                        align: pw.TextAlign.right,
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
            pw.SizedBox(height: 16),
          ],
          
          pw.Divider(thickness: 2),
          pw.SizedBox(height: 16),
          
          // Detail Transaksi
          pw.Text(
            'DETAIL TRANSAKSI',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.5),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(1.5),
              4: const pw.FlexColumnWidth(2),
            },
            children: [
              // Header
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _buildTableCell('Tanggal', isHeader: true),
                  _buildTableCell('Nama', isHeader: true),
                  _buildTableCell('Kategori', isHeader: true),
                  _buildTableCell('Jenis', isHeader: true),
                  _buildTableCell('Jumlah', isHeader: true, align: pw.TextAlign.right),
                ],
              ),
              
              // Data rows
              ...filteredList.map((transaksi) {
                final isPemasukan = transaksi.jenis == MutasiType.pemasukan;
                return pw.TableRow(
                  children: [
                    _buildTableCell(DateFormat('dd/MM/yy').format(transaksi.tanggal)),
                    _buildTableCell(transaksi.nama),
                    _buildTableCell(transaksi.kategori ?? '-'),
                    _buildTableCell(
                      isPemasukan ? 'Masuk' : 'Keluar',
                      color: isPemasukan ? PdfColors.green700 : PdfColors.red700,
                    ),
                    _buildTableCell(
                      _formatCurrency.format(transaksi.jumlah),
                      align: pw.TextAlign.right,
                      color: isPemasukan ? PdfColors.green700 : PdfColors.red700,
                    ),
                  ],
                );
              }).toList(),
              
              // Total row
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                children: [
                  _buildTableCell('', isHeader: true),
                  _buildTableCell('', isHeader: true),
                  _buildTableCell('', isHeader: true),
                  _buildTableCell('TOTAL', isHeader: true, align: pw.TextAlign.right),
                  _buildTableCell(
                    _formatCurrency.format(totalPemasukan - totalPengeluaran),
                    isHeader: true,
                    align: pw.TextAlign.right,
                    color: saldo >= 0 ? PdfColors.green700 : PdfColors.red700,
                  ),
                ],
              ),
            ],
          ),
        ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 8),
          child: pw.Text(
            'Halaman ${context.pageNumber} dari ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
      ),
    );

    // Preview dan print
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Laporan_Mutasi_${_selectedYear}_${_selectedMonth.toString().padLeft(2, '0')}.pdf',
    );
  }

  pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    pw.TextAlign align = pw.TextAlign.left,
    PdfColor? color,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 9 : 8,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color,
        ),
        textAlign: align,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan loading sampai locale ready
    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Laporan Mutasi'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final transaksiAsync = ref.watch(allTransactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan Mutasi'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: transaksiAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.refresh(allTransactionsProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (transaksiList) {
          final filteredList = _filterTransaksi(transaksiList);
          
          // Hitung total dari filtered list
          double totalPemasukan = 0;
          double totalPengeluaran = 0;
          
          final Map<String, double> kategoriPemasukan = {};
          final Map<String, double> kategoriPengeluaran = {};
          
          for (var transaksi in filteredList) {
            if (transaksi.jenis == MutasiType.pemasukan) {
              totalPemasukan += transaksi.jumlah;
              final kat = transaksi.kategori ?? 'Lainnya';
              kategoriPemasukan[kat] = (kategoriPemasukan[kat] ?? 0) + transaksi.jumlah;
            } else {
              totalPengeluaran += transaksi.jumlah;
              final kat = transaksi.kategori ?? 'Lainnya';
              kategoriPengeluaran[kat] = (kategoriPengeluaran[kat] ?? 0) + transaksi.jumlah;
            }
          }
          
          final saldo = totalPemasukan - totalPengeluaran;
          
          // Get unique categories
          final allKategori = transaksiList
              .map((e) => e.kategori)
              .where((e) => e != null)
              .toSet()
              .toList()
            ..sort();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Filter Card
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.filter_list, color: Colors.blue),
                              const SizedBox(width: 8),
                              const Text(
                                'Filter Laporan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          
                          // Periode Bulan
                          const Text(
                            'Periode',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: DropdownButtonFormField<int>(
                                  decoration: const InputDecoration(
                                    labelText: 'Bulan',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  value: _selectedMonth,
                                  items: List.generate(12, (index) {
                                    final month = index + 1;
                                    return DropdownMenuItem(
                                      value: month,
                                      child: Text(DateFormat('MMMM', 'id_ID').format(DateTime(2024, month))),
                                    );
                                  }),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedMonth = value!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  decoration: const InputDecoration(
                                    labelText: 'Tahun',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  value: _selectedYear,
                                  items: List.generate(5, (index) {
                                    final year = DateTime.now().year - index;
                                    return DropdownMenuItem(
                                      value: year,
                                      child: Text(year.toString()),
                                    );
                                  }),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedYear = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Jenis Transaksi
                          const Text(
                            'Jenis Transaksi',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                value: 'Semua',
                                label: Text('Semua'),
                                icon: Icon(Icons.all_inclusive, size: 16),
                              ),
                              ButtonSegment(
                                value: 'Pemasukan',
                                label: Text('Pemasukan'),
                                icon: Icon(Icons.arrow_downward, size: 16),
                              ),
                              ButtonSegment(
                                value: 'Pengeluaran',
                                label: Text('Pengeluaran'),
                                icon: Icon(Icons.arrow_upward, size: 16),
                              ),
                            ],
                            selected: {_selectedJenis},
                            onSelectionChanged: (selected) {
                              setState(() {
                                _selectedJenis = selected.first;
                              });
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Kategori
                          DropdownButtonFormField<String?>(
                            decoration: const InputDecoration(
                              labelText: 'Kategori',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.category),
                            ),
                            value: _selectedKategori,
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('Semua Kategori'),
                              ),
                              ...allKategori.map((kategori) {
                                return DropdownMenuItem(
                                  value: kategori,
                                  child: Text(kategori!),
                                );
                              }).toList(),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedKategori = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Summary Card
                  Card(
                    elevation: 2,
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.assessment, color: Colors.purple),
                              const SizedBox(width: 8),
                              const Text(
                                'Ringkasan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.arrow_downward, color: Colors.green.shade700, size: 20),
                                    const SizedBox(width: 8),
                                    const Text('Pemasukan:'),
                                  ],
                                ),
                                Text(
                                  _formatCurrency.format(totalPemasukan),
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.arrow_upward, color: Colors.red.shade700, size: 20),
                                    const SizedBox(width: 8),
                                    const Text('Pengeluaran:'),
                                  ],
                                ),
                                Text(
                                  _formatCurrency.format(totalPengeluaran),
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const Divider(height: 24),
                          
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: saldo >= 0 ? Colors.green.shade100 : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: saldo >= 0 ? Colors.green.shade300 : Colors.red.shade300,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      saldo >= 0 ? Icons.trending_up : Icons.trending_down,
                                      color: saldo >= 0 ? Colors.green.shade700 : Colors.red.shade700,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Saldo:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  _formatCurrency.format(saldo),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: saldo >= 0 ? Colors.green.shade700 : Colors.red.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          Center(
                            child: Text(
                              'Total ${filteredList.length} transaksi',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Kategori Cards
                  if (_selectedJenis != 'Pengeluaran' && kategoriPemasukan.isNotEmpty)
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.pie_chart, color: Colors.green.shade700),
                                const SizedBox(width: 8),
                                const Text(
                                  'Pemasukan per Kategori',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 16),
                            ...kategoriPemasukan.entries.map((entry) {
                              final persentase = (entry.value / totalPemasukan * 100);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(entry.key, style: const TextStyle(fontSize: 12)),
                                        Text(
                                          _formatCurrency.format(entry.value),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green.shade700,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: LinearProgressIndicator(
                                            value: persentase / 100,
                                            backgroundColor: Colors.green.shade100,
                                            valueColor: AlwaysStoppedAnimation(Colors.green.shade700),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${persentase.toStringAsFixed(1)}%',
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            })
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.print),
                      onPressed: () async {
                        final data = await ref.read(allTransactionsProvider.future);
                        final pdfBytes = await MutasiPdfGenerator.generatePDF(data);
                        await Printing.layoutPdf(
                          onLayout: (format) async => pdfBytes,
                          );
                        },
                      ),
                ]),
              ),
            );
        },
      ),
    );
  }
}
 