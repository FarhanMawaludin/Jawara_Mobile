import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // TAMBAHKAN
import '../../../domain/entities/mutasi.dart';
import '../../providers/mutasi/mutasi_providers.dart';

class StatistikKeuanganPage extends ConsumerWidget {
  const StatistikKeuanganPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mutasiAsync = ref.watch(allTransactionsProvider);
    
    // TAMBAHKAN Currency Formatter
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistik"),
      ),
      body: mutasiAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (List<Mutasi> data) {
          // =============================
          // HITUNG STATISTIK
          // =============================
          final totalPemasukan = data
              .where((m) => m.jenis == MutasiType.pemasukan)
              .fold<double>(0, (s, m) => s + m.jumlah);

          final totalPengeluaran = data
              .where((m) => m.jenis == MutasiType.pengeluaran)
              .fold<double>(0, (s, m) => s + m.jumlah);

          final totalTransaksi = data.length;

          // Line chart (12 bulan)
          final pemasukanPerBulan = List<double>.filled(12, 0);
          final pengeluaranPerBulan = List<double>.filled(12, 0);

          for (var m in data) {
            if (m.jenis == MutasiType.pemasukan) {
              pemasukanPerBulan[m.tanggal. month - 1] += m. jumlah;
            } else {
              pengeluaranPerBulan[m.tanggal.month - 1] += m.jumlah;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ===========================
                // SUMMARY CARD (GUNAKAN currencyFormatter)
                // ===========================
                Row(
                  children: [
                    _SummaryCard(
                      title: "Total Pemasukan",
                      value: currencyFormatter.format(totalPemasukan), // FORMAT
                      subtitle: "Keluarga",
                      icon: Icons.arrow_upward,
                      color: Colors.green,
                    ),
                    _SummaryCard(
                      title: "Total Pengeluaran",
                      value: currencyFormatter.format(totalPengeluaran), // FORMAT
                      subtitle: "Anggota",
                      icon: Icons.arrow_downward,
                      color: Colors.red,
                    ),
                    _SummaryCard(
                      title: "Jumlah Transaksi",
                      value: totalTransaksi.toString(),
                      subtitle: "Transaksi",
                      icon:  Icons.receipt_long,
                      color: Colors.blueGrey,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ===========================
                // LINE CHART PEMASUKAN
                // ===========================
                const _SectionTitle("Total Pemasukan"),
                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child:  _LineChart(
                      color: Colors.blueAccent,
                      data: List.generate(
                          12,
                          (i) => FlSpot(
                              i.toDouble(), pemasukanPerBulan[i].toDouble())),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ===========================
                // LINE CHART PENGELUARAN
                // ===========================
                const _SectionTitle("Total Pengeluaran"),
                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child:  _LineChart(
                      color: Colors.redAccent,
                      data: List.generate(
                          12,
                          (i) => FlSpot(
                              i.toDouble(), pengeluaranPerBulan[i].toDouble())),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ===========================
                // DONUT CHART PEMASUKAN (GUNAKAN currencyFormatter)
                // ===========================
                const _SectionTitle("Kategori Pemasukan"),
                const SizedBox(height: 16),

                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _DonutChart(
                      total: currencyFormatter.format(totalPemasukan), // FORMAT
                      color: Colors.orange,
                      label1: "Dana Pemerintah",
                      label2: "Pendapatan Lainnya",
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ===========================
                // DONUT CHART PENGELUARAN (GUNAKAN currencyFormatter)
                // ===========================
                const _SectionTitle("Kategori Pengeluaran"),
                const SizedBox(height: 16),

                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets. all(20),
                    child: _DonutChart(
                      total: currencyFormatter.format(totalPengeluaran), // FORMAT
                      color: Colors.blueAccent,
                      label1: "Operasional RT/RW",
                      label2: "Kegiatan Warga",
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this. title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child:  Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 6),
              Text(
                value, 
                style: const TextStyle(
                  fontSize: 18, // Dikecilkan sedikit karena ada "Rp"
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center, // Agar rapi
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                subtitle, 
                style: const TextStyle(fontSize: 10, color: Colors. grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style:  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  final Color color;
  final List<FlSpot> data;

  const _LineChart({
    required this.color,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:  180,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 11,
          minY: 0,
          titlesData: FlTitlesData(show: false),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots:  data,
              isCurved: true,
              color: color,
              barWidth: 3,
              belowBarData:  BarAreaData(
                show: true,
                color: color.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DonutChart extends StatelessWidget {
  final String total;
  final Color color;
  final String label1;
  final String label2;

  const _DonutChart({
    required this.total,
    required this.color,
    required this. label1,
    required this. label2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height:  170,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  value: 50,
                  color: Colors.blueAccent,
                  radius: 45,
                  title: "",
                ),
                PieChartSectionData(
                  value: 50,
                  color: Colors.orange,
                  radius: 45,
                  title: "",
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          total,
          style: const TextStyle(fontSize:  20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(label1, textAlign: TextAlign.center),
        Text(label2, textAlign: TextAlign.center),
      ],
    );
  }
}