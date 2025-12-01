import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/kegiatan_list.dart';
import 'kegiatan_skeleton_list.dart';
import 'kegiatan_error_state.dart';
import 'kegiatan_empty_state.dart';
import 'kegiatan_list_view.dart';

class DaftarKegiatanBody extends ConsumerWidget {
  const DaftarKegiatanBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(kegiatanListNotifierProvider);

    if (state.isLoading && state.items.isEmpty) {
      return const KegiatanSkeletonList();
    }

    if (state.error != null && state.items.isEmpty) {
      return KegiatanErrorState(
        errorMessage: state.error!,
        onRetry: () {
          ref.read(kegiatanListNotifierProvider.notifier).refresh();
        },
      );
    }

    if (state.items.isEmpty) {
      return const KegiatanEmptyState();
    }

    return KegiatanListView(
      items: state.items,
      hasMore: state.hasMore,
      onLoadMore: () {
        ref.read(kegiatanListNotifierProvider.notifier).loadMore();
      },
      onRefresh: () {
        return ref.read(kegiatanListNotifierProvider.notifier).refresh();
      },
    );
  }
}