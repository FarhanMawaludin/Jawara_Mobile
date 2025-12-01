import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogActivityModel {
  final int id;
  final String title;
  final String? userId;
  final String actor;
  final String category;
  final String? details;
  
  final DateTime createdAt;

  LogActivityModel({
    required this.id,
    required this.title,
    this.userId,
    required this.actor,
    required this.category,
    this.details,
    required this.createdAt,
  });

  factory LogActivityModel.fromMap(Map<String, dynamic> m) {
    return LogActivityModel(
      id: m['id'] is int ? m['id'] as int : int.parse(m['id'].toString()),
      title: (m['title'] ?? '').toString(),
      userId: (m['user_id'] ?? m['userId'])?.toString(),
      actor: (m['actor'] ?? '').toString(),
      category: (m['category'] ?? '').toString(),
      details: m['details']?.toString(),
      createdAt: DateTime.parse((m['created_at'] ?? m['createdAt']).toString()),
    );
  }
}

// Provide Supabase client
final supabaseClientProviderForLog = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// FutureProvider that fetches log_activity rows
final logActivityListProvider = FutureProvider<List<LogActivityModel>>((ref) async {
  final client = ref.read(supabaseClientProviderForLog);
  try {
    final List<dynamic> raw = await client.from('log_activity').select().order('created_at', ascending: false) as List<dynamic>;
    return raw.map((e) => LogActivityModel.fromMap(Map<String, dynamic>.from(e as Map<String, dynamic>))).toList();
  } catch (e) {
    throw Exception('Gagal mengambil log_activity: $e');
  }
});

// FutureProvider that fetches distinct categories from log_activity
final logActivityCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final client = ref.read(supabaseClientProviderForLog);
  try {
    final List<dynamic> raw = await client.from('log_activity').select('category').order('category') as List<dynamic>;
    final cats = <String>[];
    for (final r in raw) {
      if (r is Map<String, dynamic>) {
        final c = (r['category'] ?? '').toString().trim();
        if (c.isNotEmpty) cats.add(c);
      } else if (r is Map) {
        final c = (r['category'] ?? '').toString().trim();
        if (c.isNotEmpty) cats.add(c);
      }
    }
    final uniq = cats.toSet().toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return uniq;
  } catch (e) {
    throw Exception('Gagal mengambil kategori log_activity: $e');
  }
});
