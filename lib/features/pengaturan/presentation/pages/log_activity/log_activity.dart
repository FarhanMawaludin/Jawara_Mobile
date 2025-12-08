import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/log_activity_providers.dart';

const _monthsShort = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
const _monthsLong = ['', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];

String _formatDate(DateTime t, List<String> months) => '${t.day} ${months[t.month]} ${t.year}';
String _formatDateShort(DateTime t) => _formatDate(t, _monthsShort);
String _formatDateLong(DateTime t) => _formatDate(t, _monthsLong);
Color? _colorWithAlpha(Color? c, double opacity) => c?.withAlpha((opacity * 255).round().clamp(0, 255));

class LogActivityPage extends ConsumerStatefulWidget {
  const LogActivityPage({super.key});

  @override
  ConsumerState<LogActivityPage> createState() => _LogActivityPageState();
}

class _LogActivityPageState extends ConsumerState<LogActivityPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  
  // Data is fetched via `logActivityListProvider` and filtered in the UI.

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() => _query = _searchController.text));
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
    leading: IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      icon: const Icon(Icons.arrow_back_ios, size: 18),
      onPressed: () => Navigator.maybePop(context),
    ),
    title: const Text('Log Aktivitas'),
    titleSpacing: 0,
    centerTitle: false,
    elevation: 0,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black87,
  );

  Widget _buildSearchField() => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Row(
      children: [
        const Icon(Icons.search, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(hintText: 'Cari...', border: InputBorder.none, isDense: true),
          ),
        ),
        if (_searchController.text.isNotEmpty)
          GestureDetector(
            onTap: () { _searchController.clear(); setState(() {}); },
            child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Icon(Icons.close, size: 18, color: Colors.grey)),
          )
      ],
    ),
  );

  String _groupLabel(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yday = today.subtract(const Duration(days: 1));
    return d == today ? 'Hari ini' : d == yday ? 'Kemarin' : _formatDateLong(d);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final asyncList = ref.watch(logActivityListProvider);

    return asyncList.when(
      data: (items) {
        // Determine current signed-in user id (if available) so we can show 'Anda'
        final supa = ref.read(supabaseClientProviderForLog);
        final String? currentUid = supa.auth.currentUser?.id;

        // Map DB models to local _ActivityItem for existing UI
        String actorLabelFor(m) {
          final String? userId = m.userId;
          
          // Check if it's the current user
          if (userId != null && userId.isNotEmpty) {
            if (currentUid != null && userId == currentUid) return 'Anda';
            // Show truncated user ID
            return userId.length >= 8 ? 'User ${userId.substring(0, 8)}...' : 'User $userId';
          }
          return 'Sistem';
        }

        final mapped = items
            .map((m) => _ActivityItem(
                  title: m.title,
                  actor: actorLabelFor(m),
                  time: m.createdAt,
                ))
            .toList();

        final q = _query.trim().toLowerCase();
        final filtered = mapped.where((a) {
          final title = a.title.toLowerCase();
          final actor = a.actor.toLowerCase();
          final matchesQuery = q.isEmpty || title.contains(q) || actor.contains(q);
          return matchesQuery;
        }).toList();

        // group items by date (date-only)
        final groups = <DateTime, List<_ActivityItem>>{};
        for (final it in filtered) {
          final d = DateTime(it.time.year, it.time.month, it.time.day);
          groups.putIfAbsent(d, () => []).add(it);
        }
        final sortedDates = groups.keys.toList()..sort((a, b) => b.compareTo(a));

        return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            const Divider(height: 1),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), child: _buildSearchField()),
            const SizedBox(height: 4),
            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Padding(padding: const EdgeInsets.all(24.0), child: Text('Tidak ada aktivitas.', style: theme.textTheme.bodyLarge)))
                  : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: sortedDates.length,
                          itemBuilder: (context, idx) {
                            final dateKey = sortedDates[idx];
                            final list = groups[dateKey]!..sort((a, b) => b.time.compareTo(a.time));
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                                  child: Text(
                                    _groupLabel(dateKey),
                                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                ...list.map((it) => Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 12), child: _FamilyCard(item: it))),
                              ],
                            );
                          },
                    ),
            ),
          ],
        ),
      ),
        );
      },
      loading: () => Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: const SafeArea(child: Center(child: CircularProgressIndicator())),
      ),
      error: (err, st) => Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: SafeArea(child: Center(child: Padding(padding: const EdgeInsets.all(24.0), child: Text('Gagal memuat aktivitas: $err')))),
      ),
    );
  }
}

class _ActivityItem {
  final String title;
  final DateTime time;
  final String actor;

  _ActivityItem({required this.title, required this.time, required this.actor});
}

class _FamilyCard extends StatelessWidget {
  final _ActivityItem item;
  const _FamilyCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(child: Text(item.actor, style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    _formatDateShort(item.time),
                    style: theme.textTheme.bodySmall?.copyWith(color: _colorWithAlpha(theme.textTheme.bodySmall?.color, 0.7)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

