import 'package:flutter/material.dart';

// Top-level date helpers so widgets can reuse them without requiring state access.
String _formatDateShort(DateTime t) {
  const months = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des'
  ];
  return '${t.day} ${months[t.month]} ${t.year}';
}

Color? _colorWithAlpha(Color? c, double opacity) {
  if (c == null) return null;
  final a = (opacity * 255).round().clamp(0, 255);
  return c.withAlpha(a);
}

String _formatDateLong(DateTime t) {
  const months = [
    '',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];
  return '${t.day} ${months[t.month]} ${t.year}';
}



/// Clean Log Aktivitas screen with grouping, search, and category chips.
class LogActivityPage extends StatefulWidget {
  const LogActivityPage({super.key});

  @override
  State<LogActivityPage> createState() => _LogActivityPageState();
}

class _LogActivityPageState extends State<LogActivityPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<_ActivityItem> _all = [
    _ActivityItem(title: 'Menambahkan iuran baru: Harian', actor: 'Admin Jawara', time: DateTime(2025, 10, 19), category: 'Iuran'),
    _ActivityItem(title: 'Menambahkan iuran baru: Kerja Bakti', actor: 'Admin Jawara', time: DateTime(2025, 10, 19), category: 'Iuran'),
    _ActivityItem(title: 'Mendownload laporan keuangan', actor: 'Admin Jawara', time: DateTime(2025, 10, 19), category: 'Laporan'),
    _ActivityItem(title: 'Menyetujui registrasi dari : Keluarga Farhan', actor: 'Admin Jawara', time: DateTime(2025, 10, 19), category: 'Registrasi'),
    _ActivityItem(title: 'Menugaskan tagihan : Mingguan periode Oktober 2025 sebesar Rp. 12', actor: 'Admin Jawara', time: DateTime(2025, 10, 18), category: 'Tagihan'),
    _ActivityItem(title: 'Menghapus transfer channel: Bank Mega', actor: 'Admin Jawara', time: DateTime(2025, 10, 18), category: 'Transfer'),
    _ActivityItem(title: 'Menambahkan rumah baru dengan alamat: Jl. Merbabu', actor: 'Admin Jawara', time: DateTime(2025, 10, 18), category: 'Registrasi'),
    _ActivityItem(title: 'Mengubah iuran: Agustusan', actor: 'Admin Jawara', time: DateTime(2025, 10, 17), category: 'Iuran'),
    _ActivityItem(title: 'Membuat broadcast baru: DJ BAWS', actor: 'Admin Jawara', time: DateTime(2025, 10, 17), category: 'Broadcast'),
    _ActivityItem(title: 'Menambahkan pengeluaran : Arka sebesar Rp. 6', actor: 'Admin Jawara', time: DateTime(2025, 10, 17), category: 'Pengeluaran'),
  ];

  List<_ActivityItem> get _filtered {
    final q = _searchController.text.toLowerCase();
    if (q.isEmpty) return _all;
    return _all.where((a) => a.title.toLowerCase().contains(q) || a.actor.toLowerCase().contains(q) || a.category.toLowerCase().contains(q)).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime t) => _formatDateLong(t);

  String _groupLabel(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yday = today.subtract(const Duration(days: 1));
    if (d == today) return 'Hari ini';
    if (d == yday) return 'Kemarin';
    return _formatDate(d);
  }

  // use top-level helpers: _categoryColorFor / _categoryIconFor

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = _filtered;

    // group items by date (date-only)
    final groups = <DateTime, List<_ActivityItem>>{};
    for (final it in items) {
      final d = DateTime(it.time.year, it.time.month, it.time.day);
      groups.putIfAbsent(d, () => []).add(it);
    }
    final sortedDates = groups.keys.toList()..sort((a, b) => b.compareTo(a));

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // explicit leading so we can reduce space between back icon and title
          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            icon: const Icon(Icons.arrow_back_ios, size: 18),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: const Text('Log Aktivitas'),
          // remove default title padding so title sits close to the leading icon
          titleSpacing: 0,
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
        ),
      body: SafeArea(
        child: Column(
          children: [
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.search, size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,  
                              decoration: const InputDecoration(
                                hintText: 'Cari...',
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(Icons.close, size: 18, color: Colors.grey),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(Icons.filter_list, size: 20, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? Center(child: Padding(padding: const EdgeInsets.all(24.0), child: Text('Tidak ada aktivitas.', style: theme.textTheme.bodyLarge)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      itemCount: sortedDates.length,
                      itemBuilder: (context, idx) {
                        final dateKey = sortedDates[idx];
                        final list = groups[dateKey]!..sort((a, b) => b.time.compareTo(a.time));
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Text(
                                _groupLabel(dateKey),
                                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            ...list.map((it) => Padding(padding: const EdgeInsets.only(bottom: 12.0), child: _FamilyCard(item: it))),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem {
  final String title;
  final DateTime time;
  final String actor;
  final String category;

  _ActivityItem({required this.title, required this.time, required this.actor, this.category = 'Lainnya'});
}

// _ActivityCard removed — replaced by _FamilyCard above which reuses the same data.

// New family-style card used to display items in the requested model UI.
class _FamilyCard extends StatelessWidget {
  final _ActivityItem item;
  const _FamilyCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // For this mock UI we reuse item.title as the family name and hardcode other details
  final familyName = item.title;
  // derive role in a simple deterministic way from data
  final role = 'Admin';

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    familyName,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(role, style: theme.textTheme.bodySmall),
                const SizedBox(width: 12),
                // show a compact date so top-level helpers are referenced
                Text(_formatDateShort(item.time), style: theme.textTheme.bodySmall?.copyWith(color: _colorWithAlpha(theme.textTheme.bodySmall?.color, 0.7))),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

