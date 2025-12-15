import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../aspirasi/presentations/providers/aspirasi_providers.dart';
import '../../../../../aspirasi/data/models/aspiration_model.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/aspiration_detail.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_model.dart'
    as ui_model;

class Aspirasi extends ConsumerStatefulWidget {
  const Aspirasi({super.key});

  @override
  ConsumerState<Aspirasi> createState() => _AspirasiState();
}

class _AspirasiState extends ConsumerState<Aspirasi> {

  String _relativeTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    // Prefer showing days only. If the timestamp appears to be in the future
    final days = diff.isNegative ? 0 : diff.inDays;
    if (days == 0) return 'Hari ini';
    return '$days hari lalu';
  }

  @override
  Widget build(BuildContext context) {
    final asyncList = ref.watch(aspirationListProvider);

    return Container(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pesan Warga",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 16),

              InkWell(
                onTap: () {
                  context.push('/warga/aspirasi');
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Lihat Semua",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        HeroiconsMini.chevronRight,
                        size: 24, 
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // List Pesan (from aspirasi)
          asyncList.when(
            data: (items) {
              if (items.isEmpty) return const Text('Belum ada pesan.');
              // show up to 3 latest
              final latest = List<AspirationModel>.from(items)
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
              final show = latest.take(3).toList();
              return Column(
                children: show.map((e) {
                  final displayName = (e.sender.split('@').first).trim();
                  final isRead = e.isRead == true;
                  final tile = _buildMessageTile(
                    imageUrl: null,
                    name: displayName.isNotEmpty ? displayName : 'Warga',
                    message: e.message.isNotEmpty ? e.message : e.title,
                    time: _relativeTime(e.createdAt),
                    isRead: isRead,
                  );

                  return InkWell(
                    onTap: () async {
                      if (e.id != null && !isRead) {
                        await ref.read(aspirationRemoteDataSourceProvider).markAsRead(e.id!);
                        ref.invalidate(aspirationListProvider);
                      }

                      final item = ui_model.AspirationItem(
                        id: e.id,
                        sender: e.sender,
                        title: e.title,
                        status: e.status,
                        date: e.createdAt,
                        message: e.message,
                        isRead: true,
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AspirationDetailPage(item: item),
                        ),
                      );
                    },
                    child: tile,
                  );
                }).toList(),
              );
            },
            loading: () => const SizedBox(
              height: 56,
              child: Center(child: CircularProgressIndicator()),
            ),
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
    bool isRead = true,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Stack(
        children: [
          Container(
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
                  : Center(
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ),
          ),
          if (!isRead)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                constraints: const BoxConstraints(
                  minWidth: 10,
                  minHeight: 10,
                ),
              ),
            ),
        ],
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isRead ? FontWeight.w600 : FontWeight.w700,
          color: Colors.grey[900],
        ),
      ),
      subtitle: Text(
        message,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: isRead ? FontWeight.w400 : FontWeight.w500,
          color: isRead ? Colors.grey[600] : Colors.grey[800],
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isRead ? FontWeight.w400 : FontWeight.w600,
              color: isRead ? Colors.grey[500] : Colors.deepPurpleAccent,
            ),
          ),
          if (!isRead) const SizedBox(height: 4),
          if (!isRead)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Baru',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
