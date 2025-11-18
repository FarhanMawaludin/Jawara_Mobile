import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

class StatistikPage extends StatelessWidget {
  const StatistikPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistik"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== CARD SUMMARY =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _SummaryCard(
                  title: "Total Pemasukan",
                  value: "6",
                  subtitle: "Keluarga",
                  icon: Icons.arrow_upward,
                  color: Colors.green,
                ),
                _SummaryCard(
                  title: "Total Pengeluaran",
                  value: "12",
                  subtitle: "Anggota",
                  icon: Icons.arrow_downward,
                  color: Colors.red,
                ),
                _SummaryCard(
                  title: "Jumlah Transaksi",
                  value: "12",
                  subtitle: "Anggota",
                  icon: Icons.receipt_long,
                  color: Colors.blueGrey,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ===== LINE CHART PEMASUKAN =====
            const _SectionTitle("Total Pemasukan"),
            const SizedBox(height: 20),
            _LineChart(
              color: Colors.blueAccent,
              data: const [
                FlSpot(0, 60),
                FlSpot(1, 75),
                FlSpot(2, 70),
                FlSpot(3, 85),
              ],
            ),

            const SizedBox(height: 24),

            // ===== LINE CHART PENGELUARAN =====
            const _SectionTitle("Total Pengeluaran"),
            const SizedBox(height: 20),
            _LineChart(
              color: Colors.redAccent,
              data: const [
                FlSpot(0, 60),
                FlSpot(1, 65),
                FlSpot(2, 55),
                FlSpot(3, 90),
              ],
            ),

            const SizedBox(height: 24),

            // ===== KATEGORI PEMASUKAN =====
            const _SectionTitle("Kategori Pemasukan"),
            const SizedBox(height: 16),
            const _DonutChart(
              total: "100",
              color: Colors.blueAccent,
              label1: "Dana Pemerintah",
              label2: "Pendapatan Lainnya",
            ),

            const SizedBox(height: 24),

            // ===== KATEGORI PENGELUARAN =====
            const _SectionTitle("Kategori Pengeluaran"),
            const SizedBox(height: 16),
            const _DonutChart(
              total: "200",
              color: Colors.redAccent,
              label1: "Operasional RT/RW",
              label2: "Kegiatan Warga",
            ),
          ],
        ),
      ),
    );
  }
}

// =========================
// ======= WIDGETS =========
// =========================

class _SummaryCard extends StatelessWidget {
  final String title, value, subtitle;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 6),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value,
                  style: TextStyle(
                      color: color,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              Text(subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}

// ======================
// LINE CHART
// ======================
class _LineChart extends StatelessWidget {
  final Color color;
  final List<FlSpot> data;

  const _LineChart({required this.color, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 100,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  final months = ["Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul"];
                  if (value < months.length) {
                    return Text(months[value.toInt()],
                        style: const TextStyle(fontSize: 12));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: color,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: color.withOpacity(0.2),
              ),
              spots: data,
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================
// DONUT CHART
// ======================
class _DonutChart extends StatelessWidget {
  final String total;
  final Color color;
  final String label1;
  final String label2;

  const _DonutChart({
    required this.total,
    required this.color,
    required this.label1,
    required this.label2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 45,
                  sectionsSpace: 2,
                  sections: [
                    PieChartSectionData(
                      color: color,
                      value: 60,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      color: Colors.orangeAccent,
                      value: 40,
                      showTitle: false,
                    ),
                  ],
                ),
              ),
            ),
            Text(
              total,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendDot(color: color, label: label1),
            const SizedBox(width: 16),
            _LegendDot(color: Colors.orangeAccent, label: label2),
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
