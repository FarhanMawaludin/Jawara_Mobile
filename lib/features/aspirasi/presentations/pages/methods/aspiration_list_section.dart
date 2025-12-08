import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_list_item.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_model.dart' as ui_model;
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/search_bar.dart';
import 'package:jawaramobile/features/aspirasi/presentations/providers/aspirasi_providers.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final Set<String> _locallyRead = {};
  late SharedPreferences _prefs;

  String _makeKey(dynamic e) {
    // Prefer persistent id if available; fallback to content-based key.
    final idPart = (e.id != null ? e.id.toString() : null);
    return idPart ?? '${e.sender}|${e.title}|${e.createdAt.toIso8601String()}';
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text;
      });
    });
    _loadReadStatus();
  }

  Future<void> _loadReadStatus() async {
    _prefs = await SharedPreferences.getInstance();
    final readList = _prefs.getStringList('aspirasi_read_items') ?? [];
    setState(() {
      _locallyRead.addAll(readList);
    });
  }

  Future<void> _saveReadStatus(String key) async {
    final readList = _prefs.getStringList('aspirasi_read_items') ?? [];
    if (!readList.contains(key)) {
      readList.add(key);
      await _prefs.setStringList('aspirasi_read_items', readList);
    }
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

          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Filter Aspirasi',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 20),
            ),
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
                      title: Text(
                        s,
                        style: TextStyle(
                          color: tempStatus == s ? Colors.deepPurpleAccent[400] : null,
                        ),
                      ),
                      value: s,
                      groupValue: tempStatus,
                      activeColor: Colors.deepPurpleAccent[400],
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
                  backgroundColor: Colors.deepPurpleAccent[400],
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
        final latest = <MapEntry<String, ui_model.AspirationItem>>[]; // <=24h
        final week = <MapEntry<String, ui_model.AspirationItem>>[]; // >24h && <=7d
        // For items older than 7 days, group them by their calendar date
        final Map<DateTime, List<MapEntry<String, ui_model.AspirationItem>>> dayGroups = {};

        for (final e in filtered) {
          final itemKey = _makeKey(e);
          final diff = now.difference(e.createdAt);
          
          // Hanya pesan terbaru (<=24h) yang bisa ditandai belum dibaca
          final isLatest = diff.inHours <= 24;
          final isReadStatus = isLatest ? (e.isRead || _locallyRead.contains(itemKey)) : true;
          
          final ui = ui_model.AspirationItem(
            sender: e.sender,
            title: e.title,
            status: e.status,
            date: e.createdAt,
            message: e.message,
            isRead: isReadStatus,
          );
          
          if (diff.inHours <= 24) {
            latest.add(MapEntry(itemKey, ui));
          } else if (diff.inDays <= 7) {
            week.add(MapEntry(itemKey, ui));
          } else {
            final dateKey = DateTime(e.createdAt.year, e.createdAt.month, e.createdAt.day);
            dayGroups.putIfAbsent(dateKey, () => []).add(MapEntry(itemKey, ui));
          }
        }

        // Build a flattened list of widgets: section header + items
        final sectionWidgets = <Widget>[];
        void addSection(String title, List<MapEntry<String, ui_model.AspirationItem>> entries) {
          if (entries.isEmpty) return; // Skip empty sections
          sectionWidgets.add(Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          ));
          for (var i = 0; i < entries.length; i++) {
            final entry = entries[i];
            sectionWidgets.add(Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AspirationListItem(
                item: entry.value,
                onMarkedRead: () async {
                  await _saveReadStatus(entry.key);
                  setState(() {
                    _locallyRead.add(entry.key);
                  });
                },
              ),
            ));
            // add small separator between items
            sectionWidgets.add(const SizedBox(height: 8));
          }
        }

        // Ensure each bucket is sorted newest-first
        latest.sort((a, b) => b.value.date.compareTo(a.value.date));
        week.sort((a, b) => b.value.date.compareTo(a.value.date));

        addSection('Terbaru', latest);
        addSection('7 Hari Terakhir', week);

        // For older items, create a section per calendar date (newest date first)
        final dayKeys = dayGroups.keys.toList();
        dayKeys.sort((a, b) => b.compareTo(a));
        for (final d in dayKeys) {
          final itemsForDay = dayGroups[d]!;
          itemsForDay.sort((a, b) => b.value.date.compareTo(a.value.date));
          final title = DateFormat('dd MMMM yyyy').format(d);
          addSection(title, itemsForDay);
        }

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
