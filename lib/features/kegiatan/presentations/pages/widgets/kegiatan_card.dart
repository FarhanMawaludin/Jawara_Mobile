import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../../../features/pengaturan/presentation/providers/log_activity_providers.dart';
import '../../../data/models/kegiatan_model.dart';
import '../../providers/kegiatan_list.dart'; // PASTIKAN IMPORT INI

// Ensure kegiatanListNotifierProvider is exported in kegiatan_list_provider.dart

class KegiatanCard extends ConsumerWidget {
  final KegiatanModel kegiatan;
  final VoidCallback? onTap;

  const KegiatanCard({
    super.key,
    required this.kegiatan,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = const Color(0xFF6C63FF);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Dismissible(
        key: ValueKey(kegiatan.id),
        direction: DismissDirection.endToStart,
        background: _buildDismissBackground(),
        confirmDismiss: (direction) => _showDeleteConfirmation(context),
        onDismissed: (direction) => _handleDelete(context, ref),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _buildIconContainer(primaryColor),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildContent(),
                  ),
                  _buildStatusBadge(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Hapus",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.delete_outline, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildIconContainer(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _getIconByKategori(),
        color: primaryColor,
        size: 24,
      ),
    );
  }

  IconData _getIconByKategori() {
    switch (kegiatan.kategoriKegiatan) {
      case KategoriKegiatan.sosial:
        return Icons.people;
      case KategoriKegiatan.keagamaan:
        return Icons.mosque;
      case KategoriKegiatan.olahraga:
        return Icons.sports_soccer;
      case KategoriKegiatan.pendidikan:
        return Icons.school;
      case KategoriKegiatan.kesehatan:
        return Icons.health_and_safety;
      default:
        return Icons.event_note;
    }
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          kegiatan.namaKegiatan.isNotEmpty
              ? kegiatan.namaKegiatan
              : 'Tanpa Nama',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 6),
            Text(
              kegiatan.tanggalKegiatan != null
                  ? DateFormatter.formatDate(kegiatan.tanggalKegiatan)
                  : 'Tanggal belum ditentukan',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
        if (kegiatan.lokasiKegiatan != null &&
            kegiatan.lokasiKegiatan!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  kegiatan.lokasiKegiatan!,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStatusBadge() {
    final status = kegiatan.status;
    Color badgeColor;

    switch (status) {
      case 'Selesai':
        badgeColor = Colors.green;
        break;
      case 'Hari Ini':
        badgeColor = Colors.blue;
        break;
      case 'Akan Datang':
        badgeColor = Colors.orange;
        break;
      default:
        badgeColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: badgeColor,
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Hapus Kegiatan"),
              content: Text(
                "Apakah Anda yakin ingin menghapus kegiatan '${kegiatan.namaKegiatan}'?",
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    "Batal",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Hapus",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(kegiatanListNotifierProvider.notifier);

    notifier.removeById(kegiatan.id);

    final result = await notifier.deleteById(kegiatan.id);

    // Log activity
    await ref
        .read(logActivityNotifierProvider.notifier)
        .createLogWithCurrentUser(
            title: 'Menghapus kegiatan: ${kegiatan.namaKegiatan}');

    if (!context.mounted) return;

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${kegiatan.namaKegiatan} berhasil dihapus"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF6C63FF),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal menghapus kegiatan'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      notifier.refresh();
    }
  }
}