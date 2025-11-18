import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class StatistikPage extends StatelessWidget {
  const StatistikPage({super.key});

  @override
  Widget build(BuildContext context) {
    const totalKeluarga = 6;
    const totalWarga = 12;

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
              aktif: 508,
              nonaktif: 120,
              labelAktif: "Aktif",
              labelNonaktif: "Nonaktif",
            ),
            _buildChartCard(
              title: "Jenis Kelamin",
              aktif: 200,
              nonaktif: 180,
              labelAktif: "Laki-laki",
              labelNonaktif: "Perempuan",
            ),
            _buildChartCard(
              title: "Pekerjaan",
              aktif: 500,
              nonaktif: 150,
              labelAktif: "Pelajar",
              labelNonaktif: "Lainnya",
            ),
            _buildChartCardTigaKategori(
              title: "Peran Dalam Keluarga",
              kepala: 700,
              anak: 300,
              anggota: 100,
            ),
            _buildChartCard(
              title: "Agama",
              aktif: 800,
              nonaktif: 100,
              labelAktif: "Islam",
              labelNonaktif: "Katolik",
            ),
            _buildChartCard(
              title: "Pendidikan",
              aktif: 800,
              nonaktif: 250,
              labelAktif: "Sarjana/Diploma",
              labelNonaktif: "SD",
            ),
          ],
        ),
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
    double aktifPercent = (aktif / total) * 100;
    double nonaktifPercent = (nonaktif / total) * 100;

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
                    sections: [
                      PieChartSectionData(
                        color: Colors.orange,
                        value: aktifPercent,
                        radius: 20,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: Colors.deepPurpleAccent,
                        value: nonaktifPercent,
                        radius: 20,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      aktif.toString(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      labelAktif,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Colors.orange, labelAktif),
              const SizedBox(width: 20),
              _buildLegendItem(Colors.deepPurpleAccent, labelNonaktif),
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
    double kepalaPercent = (kepala / total) * 100;
    double anakPercent = (anak / total) * 100;
    double anggotaPercent = (anggota / total) * 100;

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
                    sections: [
                      PieChartSectionData(
                        color: Colors.orange,
                        value: kepalaPercent,
                        radius: 20,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: Colors.blueAccent,
                        value: anakPercent,
                        radius: 20,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: Colors.green,
                        value: anggotaPercent,
                        radius: 20,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      kepala.toString(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Kepala Keluarga",
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Colors.orange, "Kepala Keluarga"),
              const SizedBox(width: 20),
              _buildLegendItem(Colors.blueAccent, "Anak"),
              const SizedBox(width: 20),
              _buildLegendItem(Colors.green, "Anggota Lain"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
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
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}