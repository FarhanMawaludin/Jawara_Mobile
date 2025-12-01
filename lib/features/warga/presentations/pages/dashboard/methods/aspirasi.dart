import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../aspirasi/presentations/providers/aspirasi_providers.dart';
import '../../../../../aspirasi/data/models/aspiration_model.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/aspiration_detail.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_model.dart' as ui_model;

class Aspirasi extends ConsumerWidget {
  const Aspirasi({super.key});

  String _relativeTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    // Prefer showing days only. If the timestamp appears to be in the future
    final days = diff.isNegative ? 0 : diff.inDays;
    if (days == 0) return 'Hari ini';
    return '$days hari lalu';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(aspirationListProvider);

    return Container(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Pesan Warga",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      context.push('/warga/aspirasi');
                    },
                    child: Text(
                      "Lihat Semua",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.deepPurpleAccent[400],
                      ),
                    ),
                  ),
                  Icon(
                    HeroiconsMini.chevronRight,
                    size: 24,
                    color: Colors.deepPurpleAccent[400],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // List Pesan (from aspirasi)
          asyncList.when(
            data: (items) {
              if (items.isEmpty) return const Text('Belum ada pesan.');
              // show up to 3 latest
              final latest = List<AspirationModel>.from(items)..sort((a,b) => b.createdAt.compareTo(a.createdAt));
              final show = latest.take(3).toList();
              return Column(
                children: show.map((e) {
                  final displayName = (e.sender.split('@').first).trim();
                  final tile = _buildMessageTile(
                    imageUrl: null,
                    name: displayName.isNotEmpty ? displayName : 'Warga',
                    message: e.message.isNotEmpty ? e.message : e.title,
                    time: _relativeTime(e.createdAt),
                  );

                  return InkWell(
                    onTap: () {
                      final item = ui_model.AspirationItem(
                        sender: e.sender,
                        title: e.title,
                        status: e.status,
                        date: e.createdAt,
                        message: e.message,
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => AspirationDetailPage(item: item)),
                      );
                    },
                    child: tile,
                  );
                }).toList(),
              );
            },
            loading: () => const SizedBox(height: 56, child: Center(child: CircularProgressIndicator())),
            error: (err, st) => Text('Gagal memuat pesan: $err'),
          ),
        ],
      ),
    );
  }

  // Komponen ListTile supaya bisa dipakai ulang
  Widget _buildMessageTile({
    String? imageUrl,
    required String name,
    required String message,
    required String time,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.grey[300]!, width: 1.5),
          color: Colors.grey[200],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: imageUrl != null && imageUrl.isNotEmpty
              ? Image.network(imageUrl, fit: BoxFit.cover)
              : Center(child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600))),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.grey[900],
        ),
      ),
      subtitle: Text(
        message,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w400,
          color: Colors.grey[600],
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        time,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Colors.grey[500],
        ),
      ),
    );
  }
}
