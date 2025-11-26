import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_list_item.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_model.dart' as ui_model;
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/search_bar.dart';
import 'package:jawaramobile/features/aspirasi/presentations/providers/aspirasi_providers.dart';

// pagination removed — list will show all items

class AspirationListSection extends ConsumerStatefulWidget {
  const AspirationListSection({super.key});

  @override
  ConsumerState<AspirationListSection> createState() => _AspirationListSectionState();
}

class _AspirationListSectionState extends ConsumerState<AspirationListSection> {
  late final TextEditingController _searchController;
  String _query = '';
  String _statusFilter = 'All';
  

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterDialog(BuildContext context) {
    final statuses = ['All', 'Pending', 'In Progress', 'Resolved'];
    String tempStatus = _statusFilter;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          // date range removed — only status filter remains

          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Filter Aspirasi'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Status'),
                  const SizedBox(height: 6),
                  for (final s in statuses)
                    RadioListTile<String>(
                      dense: true,
                      title: Text(s),
                      value: s,
                      groupValue: tempStatus,
                      activeColor: Colors.grey[700],
                      onChanged: (v) => setStateDialog(() => tempStatus = v ?? 'All'),
                    ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => setStateDialog(() { tempStatus = 'All'; }),
                    icon: Icon(Icons.clear, size: 18, color: Colors.grey[700]),
                    label: Text('Reset filter', style: TextStyle(color: Colors.grey[800])),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.grey[800]),
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  setState(() {
                    _statusFilter = tempStatus;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Terapkan'),
              ),
            ],
          );
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final asyncList = ref.watch(aspirationListProvider);

    return asyncList.when(
      data: (items) {
        // filter items by query (search sender or title)
        final q = _query.trim().toLowerCase();
        final filtered = items.where((e) {
          final sender = e.sender.toLowerCase();
          final title = e.title.toLowerCase();

          var matchesQuery = q.isEmpty || sender.contains(q) || title.contains(q);

          // status filter
          var matchesStatus = _statusFilter == 'All' || e.status.toLowerCase() == _statusFilter.toLowerCase();

          // date range filter
          // no date filtering anymore
          return matchesQuery && matchesStatus;
        }).toList();

        // Ensure newest items appear first (sort by createdAt desc)
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        // Map filtered domain models to UI items
        final now = DateTime.now();
        final latest = <ui_model.AspirationItem>[]; // <=24h
        final week = <ui_model.AspirationItem>[]; // >24h && <=7d
        final year = <ui_model.AspirationItem>[]; // >7d && <=365d
        final older = <ui_model.AspirationItem>[]; // >365d

        for (final e in filtered) {
          final ui = ui_model.AspirationItem(
            sender: e.sender,
            title: e.title,
            status: e.status,
            date: e.createdAt,
            message: e.message,
          );
          final diff = now.difference(e.createdAt);
          if (diff.inHours <= 24) {
            latest.add(ui);
          } else if (diff.inDays <= 7) {
            week.add(ui);
          } else if (diff.inDays <= 365) {
            year.add(ui);
          } else {
            older.add(ui);
          }
        }

        // Build a flattened list of widgets: section header + items
        final sectionWidgets = <Widget>[];
        void addSection(String title, List<ui_model.AspirationItem> items) {
          if (items.isEmpty) return;
          sectionWidgets.add(Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          ));
          for (var i = 0; i < items.length; i++) {
            sectionWidgets.add(Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AspirationListItem(item: items[i]),
            ));
            // add small separator between items
            sectionWidgets.add(const SizedBox(height: 8));
          }
        }

        // Ensure each bucket is sorted newest-first
        latest.sort((a, b) => b.date.compareTo(a.date));
        week.sort((a, b) => b.date.compareTo(a.date));
        year.sort((a, b) => b.date.compareTo(a.date));
        older.sort((a, b) => b.date.compareTo(a.date));

        addSection('Terbaru', latest);
        addSection('7 Hari Terakhir', week);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: AspirationSearchBar(
                controller: _searchController,
                onFilterTap: () => _showFilterDialog(context),
                onSearchChanged: (s) => setState(() => _query = s),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: sectionWidgets.length,
                itemBuilder: (context, idx) => sectionWidgets[idx],
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Gagal memuat aspirasi: $err')),
    );
  }
}
