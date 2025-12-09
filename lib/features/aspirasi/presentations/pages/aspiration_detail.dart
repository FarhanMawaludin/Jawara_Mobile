import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_model.dart';
import 'package:jawaramobile/features/aspirasi/presentations/providers/aspirasi_providers.dart';


// Chat-style detail page for aspiration message
class AspirationDetailPage extends ConsumerStatefulWidget {
  final AspirationItem item;

  const AspirationDetailPage({super.key, required this.item});

  @override
  ConsumerState<AspirationDetailPage> createState() => _AspirationDetailPageState();
}

class _AspirationDetailPageState extends ConsumerState<AspirationDetailPage> {
  @override
  void initState() {
    super.initState();
    // Mark as read when page opens
    _markAsRead();
  }

  void _markAsRead() {
    if (widget.item.id != null && !widget.item.isRead) {
      ref.read(markAspirationReadProvider(widget.item.id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String timeAgo(DateTime t) {
      final diff = DateTime.now().difference(t);
      if (diff.inSeconds < 60) return 'baru saja';
      if (diff.inMinutes < 60) return '${diff.inMinutes} menit yang lalu';
      if (diff.inHours < 24) return '${diff.inHours} jam yang lalu';
      if (diff.inDays < 7) return '${diff.inDays} hari yang lalu';
      return formatDate(t);
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Aspirasi'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 520),
                    margin: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title (status badge removed)
                        Text(
                          widget.item.title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Sender row with relative time and menu
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.purple.shade50,
                              child: Text(
                                widget.item.sender.isNotEmpty ? widget.item.sender[0].toUpperCase() : '?',
                                style: const TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.item.sender,
                                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    timeAgo(widget.item.date),
                                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            // Overflow menu removed as requested
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Message (plain, grey text to match screenshot)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            widget.item.message,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.grey.shade700,
                              height: 1.8,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
