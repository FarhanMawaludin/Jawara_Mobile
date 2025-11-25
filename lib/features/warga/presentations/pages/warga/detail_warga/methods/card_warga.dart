import 'package:flutter/material.dart';

class CardWarga extends StatelessWidget {
  final String ttl;
  final String noTelepon;
  final String jenisKelamin;
  final String agama;
  final String golonganDarah;
  final String pendidikan;
  final String pekerjaan;
  final String peranKeluarga;
  final String statusPenduduk;

  const CardWarga({
    super.key,
    required this.ttl,
    required this.noTelepon,
    required this.jenisKelamin,
    required this.agama,
    required this.golonganDarah,
    required this.pendidikan,
    required this.pekerjaan,
    required this.peranKeluarga,
    required this.statusPenduduk,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TETAP SAMA, hanya ubah teks menjadi variabel
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InfoColumn(title: "TTL", value: ttl),
              ),
              Expanded(
                child: InfoColumn(title: "No. Telepon", value: noTelepon),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InfoColumn(title: "Jenis Kelamin", value: jenisKelamin),
              ),
              Expanded(
                child: InfoColumn(title: "Agama", value: agama),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: InfoColumn(title: "Golongan Darah", value: golonganDarah),
              ),
              Expanded(
                child: InfoColumn(title: "Pendidikan Terakhir", value: pendidikan),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: InfoColumn(title: "Pekerjaan", value: pekerjaan),
              ),
              Expanded(
                child: InfoColumn(title: "Peran dalam Keluarga", value: formatPeranKeluarga(peranKeluarga)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          InfoColumn(title: "Status Penduduk", value: statusPenduduk),
        ],
      ),
    );
  }
}

// Helper kecil biar rapi
class InfoColumn extends StatelessWidget {
  final String title;
  final String value;
  const InfoColumn({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
                fontSize: 14)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w600,
                fontSize: 16)),
      ],
    );
  }
}

String formatPeranKeluarga(String value) {
  final cleaned = value.replaceAll('_', ' ');
  return cleaned
      .split(' ')
      .map((e) => e.isEmpty ? e : e[0].toUpperCase() + e.substring(1))
      .join(' ');
}
