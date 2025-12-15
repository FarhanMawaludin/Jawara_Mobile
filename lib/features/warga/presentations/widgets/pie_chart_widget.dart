import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final String title;
  final Map<String, int> data;

  const PieChartWidget({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold<int>(0, (sum, value) => sum + value);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Pie Chart
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 40,
                sections: _buildSections(),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Legend List
          Column(
            children: data.entries.map((e) {
              final percentage = total == 0
                  ? 0
                  : (e.value / total * 100).toStringAsFixed(1);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getColor(e.key),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "${e.key} ($percentage%)",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Text(
                      e.value.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Membuat warna berdasarkan kategori (supaya konsisten)
  Color _getColor(String key) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.brown,
      Colors.pink,
      Colors.cyan,
      Colors.indigo,
    ];

    final index = data.keys.toList().indexOf(key);
    return colors[index % colors.length];
  }

  List<PieChartSectionData> _buildSections() {
    final List<PieChartSectionData> list = [];
    data.forEach((key, value) {
      list.add(
        PieChartSectionData(
          color: _getColor(key),
          value: value.toDouble(),
          radius: 50,
          title: "",
        ),
      );
    });
    return list;
  }
}
