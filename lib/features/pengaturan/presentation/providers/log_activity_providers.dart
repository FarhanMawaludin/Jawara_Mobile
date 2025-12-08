import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogActivityModel {
  final int id;
  final String title;
  final String? userId;
  final DateTime createdAt;

  LogActivityModel({
    required this.id,
    required this.title,
    this.userId,
    required this.createdAt,
  });

  factory LogActivityModel.fromMap(Map<String, dynamic> m) {
    return LogActivityModel(
      id: m['id'] is int ? m['id'] as int : int.parse(m['id'].toString()),
      title: (m['title'] ?? '').toString(),
      userId: (m['user_id'] ?? m['userId'])?.toString(),
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
    final List<dynamic> raw = await client
        .from('log_activity')
        .select('*')
        .order('created_at', ascending: false) as List<dynamic>;
    return raw.map((e) => LogActivityModel.fromMap(Map<String, dynamic>.from(e as Map<String, dynamic>))).toList();
  } catch (e) {
    throw Exception('Gagal mengambil log_activity: $e');
  }
});


