import 'package:flutter/material.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_list_item.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_model.dart';

// pagination removed — list will show all items

class AspirationListSection extends StatefulWidget {
  const AspirationListSection({super.key});

  @override
  State<AspirationListSection> createState() => _AspirationListSectionState();
}

class _AspirationListSectionState extends State<AspirationListSection> {
  // Sample data
  final List<AspirationItem> _items = [
    AspirationItem(
      sender: 'Harry Samit',
      title: 'Aspirasi tentang kebersihan lingkungan',
      status: 'Diterima',
      date: DateTime(2025, 1, 18),
      message:
          'Bagaimana jika ada lomba tarik tambang setiap bulan untuk meningkatkan kebersihan lingkungan dan kebersamaan warga?',
    ),
    AspirationItem(
      sender: 'Merry an',
      title: 'Usulan fasilitas olahraga',
      status: 'Pending',
      date: DateTime(2025, 1, 18),
      message:
          'Saya usul agar disediakan lapangan voli kecil di blok B agar anak-anak bisa berolahraga.',
    ),
    AspirationItem(
      sender: 'Smith',
      title: 'Permintaan perbaikan jalan',
      status: 'Diterima',
      date: DateTime(2025, 1, 18),
      message: 'Bagaimana jika ada lomba tarik tambang...',
    ),
    AspirationItem(
      sender: 'Rudi Setiawan',
      title: 'Saran kegiatan bulanan',
      status: 'Pending',
      date: DateTime(2025, 1, 15),
      message:
          'Saya menyarankan untuk mengadakan pertemuan warga sebulan sekali dengan tema yang berbeda-beda.',
    ),
    AspirationItem(
      sender: 'Sinta Dewi',
      title: 'Permohonan fasilitas taman',
      status: 'Ditolak',
      date: DateTime(2025, 1, 10),
      message:
          'Mohon dipertimbangkan untuk menambahkan bangku taman di area bermain anak.',
    ),
    AspirationItem(
      sender: 'Budi Santoso',
      title: 'Permintaan lampu jalan',
      status: 'Pending',
      date: DateTime(2025, 2, 2),
      message: 'Mohon dipasang lampu jalan di gang 3 karena gelap malam hari.',
    ),
    AspirationItem(
      sender: 'Dewi Lestari',
      title: 'Usulan kebersihan',
      status: 'Diterima',
      date: DateTime(2025, 2, 4),
      message: 'Setiap minggu diadakan kerja bakti dan pengumpulan sampah terjadwal.',
    ),
    AspirationItem(
      sender: 'Andi Wijaya',
      title: 'Permintaan pos ronda',
      status: 'Pending',
      date: DateTime(2025, 2, 7),
      message: 'Saya usul ada pos ronda baru di pojok barat perumahan.',
    ),
    AspirationItem(
      sender: 'Rina Marlina',
      title: 'Keluhan sampah',
      status: 'Diterima',
      date: DateTime(2025, 2, 9),
      message: 'Pengangkutan sampah terlalu lama, mohon diperbaiki jadwalnya.',
    ),
    AspirationItem(
      sender: 'Tono Prasetyo',
      title: 'Saran taman bermain',
      status: 'Pending',
      date: DateTime(2025, 2, 12),
      message: 'Tolong perbaiki area play ground agar aman untuk anak-anak.',
    ),
    AspirationItem(
      sender: 'Lia Kurnia',
      title: 'Usulan posyandu',
      status: 'Ditolak',
      date: DateTime(2025, 2, 14),
      message: 'Mohon diadakan posyandu setiap bulan untuk pemeriksaan balita.',
    ),
  ];

  // pagination removed - showing full list

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, idx) => AspirationListItem(item: _items[idx]),
    );
  }
}
