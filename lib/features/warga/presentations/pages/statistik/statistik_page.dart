import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/statistik/statistik_warga.dart';

class StatistikPage extends ConsumerStatefulWidget {
  const StatistikPage({super.key});

  @override
  ConsumerState<StatistikPage> createState() => _StatistikPageState();
}

class _StatistikPageState extends ConsumerState<StatistikPage> {
  final Map<String, int> _selectedIndex = {};

  @override
  Widget build(BuildContext context) {
    final statistikState = ref.watch(statistikWargaControllerProvider);

    if (statistikState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (statistikState.error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${statistikState.error}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(statistikWargaControllerProvider.notifier).retry();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    if (statistikState.data == null) {
      return const Scaffold(body: Center(child: Text('No data available')));
    }

    final data = statistikState.data!;
    final totalKeluarga = data.totalKeluarga;
    final totalWarga = data.totalWarga;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Statistik'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[300], height: 1),
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // KOTAK BESAR (WRAPPER TOTAL)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // Total Keluarga
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                HeroiconsOutline.home,
                                size: 16,
                                color: Colors.grey[800],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Total Keluarga",
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "$totalKeluarga",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Keluarga",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Total Warga
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                HeroiconsOutline.userGroup,
                                size: 16,
                                color: Colors.grey[800],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Total Warga",
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "$totalWarga",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Warga",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // CHART SECTIONS
            _buildChartCard(
              title: "Status Penduduk",
              aktif: data.aktif,
              nonaktif: data.nonaktif,
              labelAktif: "Aktif",
              labelNonaktif: "Nonaktif",
            ),
            _buildChartCard(
              title: "Jenis Kelamin",
              aktif: data.laki,
              nonaktif: data.perempuan,
              labelAktif: "Laki-laki",
              labelNonaktif: "Perempuan",
            ),
            _buildChartCardFromMap(
              title: "Pekerjaan",
              dataMap: data.pekerjaan,
              colors: [
                Colors.orange,
                Colors.deepPurpleAccent,
                Colors.teal,
                Colors.pinkAccent,
              ],
            ),
            _buildChartCardTigaKategori(
              title: "Peran Dalam Keluarga",
              kepala: data.kepalaKeluarga,
              anak: data.anak,
              anggota: data.ibuRumahTangga,
            ),
            _buildChartCardFromMap(
              title: "Agama",
              dataMap: data.agama,
              colors: [
                Colors.orange,
                Colors.green,
                Colors.blueAccent,
                Colors.redAccent,
                Colors.purpleAccent,
              ],
            ),
            _buildChartCardFromMap(
              title: "Pendidikan",
              dataMap: data.pendidikan,
              colors: [
                Colors.orange,
                Colors.blueAccent,
                Colors.green,
                Colors.amber,
                Colors.cyan,
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ====================== PIE CHART DENGAN DATA MAP ======================
  Widget _buildChartCardFromMap({
    required String title,
    required Map<String, int> dataMap,
    required List<Color> colors,
  }) {
    if (dataMap.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(child: Text('Tidak ada data')),
          ],
        ),
      );
    }

    final int actualTotal = dataMap.values.fold(0, (sum, val) => sum + val);
    final int denomTotal = actualTotal == 0
        ? 1
        : actualTotal; // avoid divide-by-zero for percentages

    final entries = dataMap.entries.toList();
    final topEntry = entries.first;
    final topCount = topEntry.value;
    final int? selected = _selectedIndex[title];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 55,
                    startDegreeOffset: -90,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, pieTouchResponse) {
                        final touched = pieTouchResponse?.touchedSection;
                        if (event == null ||
                            !event.isInterestedForInteractions ||
                            touched == null) {
                          setState(() {
                            _selectedIndex.remove(title);
                          });
                          return;
                        }
                        final idx = touched.touchedSectionIndex;
                        setState(() {
                          _selectedIndex[title] = idx;
                        });
                      },
                    ),
                    sections: entries.asMap().entries.map((e) {
                      int idx = e.key;
                      int value = e.value.value;
                      double percent = (value / denomTotal) * 100;
                      return PieChartSectionData(
                        color: colors[idx % colors.length],
                        value: percent,
                        radius: (selected == idx) ? 28 : 20,
                        showTitle: false,
                      );
                    }).toList(),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (selected != null &&
                        selected >= 0 &&
                        selected < entries.length) ...[
                      Text(
                        entries[selected].value.toString(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colors[selected % colors.length],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entries[selected].key,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ] else ...[
                      Text(
                        actualTotal.toString(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colors[0],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: entries.asMap().entries.map((e) {
              int idx = e.key;
              String label = e.value.key;
              int count = e.value.value;
              return _buildLegendItemWithCount(
                colors[idx % colors.length],
                label,
                count,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItemWithCount(Color color, String text, int count) {
    final maxWidth = MediaQuery.of(context).size.width * 0.45;
    return SizedBox(
      width: maxWidth,
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '$text ($count)',
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ====================== PIE CHART 2 BAGIAN ======================
  Widget _buildChartCard({
    required String title,
    required int aktif,
    required int nonaktif,
    required String labelAktif,
    required String labelNonaktif,
  }) {
    int total = aktif + nonaktif;
    final int denomTotal = total == 0 ? 1 : total;
    double aktifPercent = (aktif / denomTotal) * 100;
    double nonaktifPercent = (nonaktif / denomTotal) * 100;
    final int? selected = _selectedIndex[title];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 55,
                    startDegreeOffset: -90,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, resp) {
                        final touched = resp?.touchedSection;
                        if (event == null ||
                            !event.isInterestedForInteractions ||
                            touched == null) {
                          setState(() {
                            _selectedIndex.remove(title);
                          });
                          return;
                        }
                        setState(() {
                          _selectedIndex[title] = touched.touchedSectionIndex;
                        });
                      },
                    ),
                    sections: [
                      PieChartSectionData(
                        color: Colors.orange,
                        value: aktifPercent,
                        radius: (selected == 0) ? 28 : 20,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: Colors.deepPurpleAccent,
                        value: nonaktifPercent,
                        radius: (selected == 1) ? 28 : 20,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (selected != null) ...[
                      Text(
                        (selected == 0 ? aktif : nonaktif).toString(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: (selected == 0
                              ? Colors.orange
                              : Colors.deepPurpleAccent),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (selected == 0 ? labelAktif : labelNonaktif),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ] else ...[
                      Text(
                        total.toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Total',
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildLegendItem(Colors.orange, labelAktif, aktif),
              _buildLegendItem(
                Colors.deepPurpleAccent,
                labelNonaktif,
                nonaktif,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ====================== PIE CHART 3 BAGIAN (KHUSUS PERAN) ======================
  Widget _buildChartCardTigaKategori({
    required String title,
    required int kepala,
    required int anak,
    required int anggota,
  }) {
    int total = kepala + anak + anggota;
    final int denomTotal = total == 0 ? 1 : total;
    double kepalaPercent = (kepala / denomTotal) * 100;
    double anakPercent = (anak / denomTotal) * 100;
    double anggotaPercent = (anggota / denomTotal) * 100;
    final int? selected = _selectedIndex[title];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 55,
                    startDegreeOffset: -90,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, resp) {
                        final touched = resp?.touchedSection;
                        if (event == null ||
                            !event.isInterestedForInteractions ||
                            touched == null) {
                          setState(() {
                            _selectedIndex.remove(title);
                          });
                          return;
                        }
                        setState(() {
                          _selectedIndex[title] = touched.touchedSectionIndex;
                        });
                      },
                    ),
                    sections: [
                      PieChartSectionData(
                        color: Colors.orange,
                        value: kepalaPercent,
                        radius: (selected == 0) ? 28 : 20,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: Colors.blueAccent,
                        value: anakPercent,
                        radius: (selected == 1) ? 28 : 20,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: Colors.green,
                        value: anggotaPercent,
                        radius: (selected == 2) ? 28 : 20,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (selected != null && selected >= 0 && selected <= 2) ...[
                      Text(
                        (selected == 0
                                ? kepala
                                : selected == 1
                                ? anak
                                : anggota)
                            .toString(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: (selected == 0
                              ? Colors.orange
                              : selected == 1
                              ? Colors.blueAccent
                              : Colors.green),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (selected == 0
                            ? 'Kepala Keluarga'
                            : selected == 1
                            ? 'Anak'
                            : 'Anggota Lain'),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ] else ...[
                      Text(
                        total.toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Total',
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildLegendItem(Colors.orange, "Kepala Keluarga", kepala),
              _buildLegendItem(Colors.blueAccent, "Anak", anak),
              _buildLegendItem(Colors.green, "Anggota Lain", anggota),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text, int count) {
    final maxWidth = MediaQuery.of(context).size.width * 0.45;
    return SizedBox(
      width: maxWidth,
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '$text ($count)',
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
