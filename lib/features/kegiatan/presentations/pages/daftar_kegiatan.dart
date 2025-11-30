import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/kegiatan_list.dart'; // PASTIKAN IMPORT INI
import 'widgets/kegiatan_card.dart';

class DaftarKegiatanPage extends ConsumerWidget {
  const DaftarKegiatanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kegiatanState = ref.watch(kegiatanListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Kegiatan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(kegiatanListNotifierProvider.notifier).refresh();
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: _buildBody(context, ref, kegiatanState),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    KegiatanListState state,
  ) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
      );
    }

    if (state.error != null && state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Gagal memuat data',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              state.error ?? '',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  ref.read(kegiatanListNotifierProvider.notifier).refresh(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
              ),
              child: const Text(
                'Coba Lagi',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Belum ada kegiatan',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(kegiatanListNotifierProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          final kegiatan = state.items[index];
          return KegiatanCard(
            kegiatan: kegiatan,
            onTap: () {
              // TODO: Navigate to detail page
              // context.push('/kegiatan/detail', extra: kegiatan);
            },
          );
        },
      ),
    );
  }
}