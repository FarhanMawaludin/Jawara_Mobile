import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/broadcast_list_provider.dart';
import 'widgets/broadcast_card.dart';

class DaftarBroadcastPage extends ConsumerWidget {
  const DaftarBroadcastPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcastState = ref.watch(broadcastListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Broadcast',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF6C63FF),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(broadcastListNotifierProvider.notifier).refresh();
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: _buildBody(context, ref, broadcastState),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/broadcast/tambah-broadcast');
          ref.read(broadcastListNotifierProvider.notifier).refresh();
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    BroadcastListState state,
  ) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.purple),
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
            ElevatedButton(
              onPressed: () =>
                  ref.read(broadcastListNotifierProvider.notifier).refresh(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
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
            Icon(Icons.campaign_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Belum ada broadcast',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(broadcastListNotifierProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          final broadcast = state.items[index];
          return BroadcastCard(
            broadcast: broadcast,
            onTap: () {
              // TODO: Navigate to detail page
              // context.push('/broadcast/detail', extra: broadcast);
            },
          );
        },
      ),
    );
  }
}