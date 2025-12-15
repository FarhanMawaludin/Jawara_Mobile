import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/aspiration_detail.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_model.dart';
import 'package:jawaramobile/features/aspirasi/presentations/providers/aspirasi_providers.dart';


class AspirationListItem extends ConsumerWidget {
  final AspirationItem item;
  final VoidCallback? onMarkedRead;

  const AspirationListItem({super.key, required this.item, this.onMarkedRead});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final displayName = item.sender.split('@')[0].trim();

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        // Mark as read in database
        if (item.id != null && !item.isRead) {
          await ref.read(aspirationRemoteDataSourceProvider).markAsRead(item.id!);
          ref.invalidate(aspirationListProvider);
        }
        
        onMarkedRead?.call();
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => AspirationDetailPage(item: item)),
        );
        onMarkedRead?.call(); // ensure state remains read after returning
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            // Avatar with badge indicator for unread
            Stack(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey.shade200,
                  child: Text(
                    displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                    style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w600),
                  ),
                ),
                if (!item.isRead)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent[400],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 8,
                        minHeight: 8,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          displayName,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: item.isRead ? Colors.grey[600] : Colors.grey[800],
                      fontWeight: item.isRead ? FontWeight.w400 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatDate(item.date), 
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: item.isRead ? Colors.grey[500] : Colors.deepPurpleAccent[400],
                    fontWeight: item.isRead ? FontWeight.w400 : FontWeight.w600,
                  ),
                ),
                if (!item.isRead)
                  const SizedBox(height: 4),
                if (!item.isRead)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent[400],
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
          ],
        ),
      ),
    );
  }
}
