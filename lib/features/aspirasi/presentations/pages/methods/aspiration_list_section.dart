// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_list_item.dart';
// import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_model.dart' as ui_model;
// import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/search_bar.dart';
// import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/filter_dialog.dart';
// import 'package:jawaramobile/features/aspirasi/presentations/providers/aspirasi_providers.dart';
// import 'package:intl/intl.dart';
// // is_read status persisted in DB; local set only for instant UI.

// class AspirationListSection extends ConsumerStatefulWidget {
//   final int? wargaId;

//   const AspirationListSection({super.key, this.wargaId});

//   @override
//   ConsumerState<AspirationListSection> createState() => _AspirationListSectionState();
// }

// class _AspirationListSectionState extends ConsumerState<AspirationListSection> {
//   late final TextEditingController _searchController;
//   String _query = '';
//   String _statusFilter = 'All';
//   final Set<String> _locallyRead = {}; // optimistic UI only

//   String _makeKey(dynamic e) {
//     // Prefer persistent id if available; fallback to content-based key.
//     final idPart = (e.id != null ? e.id.toString() : null);
//     return idPart ?? '${e.sender}|${e.title}|${e.createdAt.toIso8601String()}';
//   }

//   @override
//   void initState() {
//     super.initState();
//     _searchController = TextEditingController();
//     _searchController.addListener(() {
//       setState(() {
//         _query = _searchController.text;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _showFilterDialog(BuildContext context) {
//     showAspirationFilterDialog(
//       context,
//       currentStatus: _statusFilter,
//       onApply: (status) => setState(() => _statusFilter = status),
//     );
//   }

//   void _addSection(List<Widget> sectionWidgets, String title, List<MapEntry<String, ui_model.AspirationItem>> entries) {
//     if (entries.isEmpty) return;
//     sectionWidgets.add(Padding(
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
//       child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
//     ));
//     for (final entry in entries) {
//       sectionWidgets.add(Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: AspirationListItem(
//           item: entry.value,
//           onMarkedRead: () => setState(() => _locallyRead.add(entry.key)),
//         ),
//       ));
//       sectionWidgets.add(const SizedBox(height: 8));
//     }
//   }

//   List<Widget> _buildSectionWidgets(List<dynamic> filtered) {
//     final now = DateTime.now();
//     final latest = <MapEntry<String, ui_model.AspirationItem>>[];
//     final week = <MapEntry<String, ui_model.AspirationItem>>[];
//     final Map<DateTime, List<MapEntry<String, ui_model.AspirationItem>>> dayGroups = {};

//     for (final e in filtered) {
//       final itemKey = _makeKey(e);
//       final diff = now.difference(e.createdAt);
//       final ui = ui_model.AspirationItem(
//         id: e.id,
//         sender: e.sender,
//         title: e.title,
//         status: e.status,
//         date: e.createdAt,
//         message: e.message,
//         // DB is source of truth; local set only to give instant UI feedback
//         isRead: e.isRead == true || _locallyRead.contains(itemKey),
//       );
      
//       if (diff.inHours <= 24) {
//         latest.add(MapEntry(itemKey, ui));
//       } else if (diff.inDays <= 7) {
//         week.add(MapEntry(itemKey, ui));
//       } else {
//         final dateKey = DateTime(e.createdAt.year, e.createdAt.month, e.createdAt.day);
//         dayGroups.putIfAbsent(dateKey, () => []).add(MapEntry(itemKey, ui));
//       }
//     }

//     final sectionWidgets = <Widget>[];
//     latest.sort((a, b) => b.value.date.compareTo(a.value.date));
//     week.sort((a, b) => b.value.date.compareTo(a.value.date));
    
//     _addSection(sectionWidgets, 'Terbaru', latest);
//     _addSection(sectionWidgets, '7 Hari Terakhir', week);

//     final dayKeys = dayGroups.keys.toList()..sort((a, b) => b.compareTo(a));
//     for (final d in dayKeys) {
//       final itemsForDay = dayGroups[d]!..sort((a, b) => b.value.date.compareTo(a.value.date));
//       _addSection(sectionWidgets, DateFormat('dd MMMM yyyy').format(d), itemsForDay);
//     }
    
//     return sectionWidgets;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Use different provider based on wargaId
//     final asyncList = widget.wargaId != null 
//       ? ref.watch(aspirationByWargaProvider(widget.wargaId!))
//       : ref.watch(aspirationListProvider);

//     return asyncList.when(
//       data: (items) {
//         final q = _query.trim().toLowerCase();
//         final filtered = items.where((e) {
//           final sender = e.sender.toLowerCase();
//           final title = e.title.toLowerCase();
//           var matchesQuery = q.isEmpty || sender.contains(q) || title.contains(q);
//           var matchesStatus = _statusFilter == 'All' || e.status.toLowerCase() == _statusFilter.toLowerCase();
//           return matchesQuery && matchesStatus;
//         }).toList()
//           ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

//         final sectionWidgets = _buildSectionWidgets(filtered);

//         return Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: AspirationSearchBar(
//                 controller: _searchController,
//                 onFilterTap: () => _showFilterDialog(context),
//                 onSearchChanged: (s) => setState(() => _query = s),
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.only(bottom: 16),
//                 itemCount: sectionWidgets.length,
//                 itemBuilder: (context, idx) => sectionWidgets[idx],
//               ),
//             ),
//           ],
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (err, st) => Center(child: Text('Gagal memuat aspirasi: $err')),
//     );
//   }
// }
