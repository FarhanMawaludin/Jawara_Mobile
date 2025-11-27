import 'package:flutter/material.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/aspiration_detail.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_model.dart';


class AspirationListItem extends StatelessWidget {
  final AspirationItem item;

  const AspirationListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = item.sender.split('@')[0].trim();

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => AspirationDetailPage(item: item)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey.shade200,
              child: Text(
                displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatDate(item.date), style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
