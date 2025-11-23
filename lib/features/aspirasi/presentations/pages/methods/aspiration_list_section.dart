import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_list_item.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_model.dart' as ui_model;
import 'package:jawaramobile/features/aspirasi/presentations/providers/aspirasi_providers.dart';

// pagination removed — list will show all items

class AspirationListSection extends ConsumerStatefulWidget {
  const AspirationListSection({super.key});

  @override
  ConsumerState<AspirationListSection> createState() => _AspirationListSectionState();
}

class _AspirationListSectionState extends ConsumerState<AspirationListSection> {
  @override
  Widget build(BuildContext context) {
    final asyncList = ref.watch(aspirationListProvider);

    return asyncList.when(
      data: (items) {
        // items: List<data_model.AspirationModel>
        final uiItems = items.map((e) => ui_model.AspirationItem(
          sender: e.sender,
          title: e.title,
          status: e.status,
          date: e.createdAt,
          message: e.message,
        )).toList();

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: uiItems.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, idx) => AspirationListItem(item: uiItems[idx]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Gagal memuat aspirasi: $err')),
    );
  }
}
