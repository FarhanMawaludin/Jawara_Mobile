import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef SupabaseClientFactory = SupabaseClient Function();
SupabaseClientFactory supabaseClientFactoryForLog = () => Supabase.instance.client; // overridable in tests

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
final supabaseClientProviderForLog = Provider<SupabaseClient>((ref) => supabaseClientFactoryForLog());

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

// =========================================================
// LOG ACTIVITY NOTIFIER - untuk create log secara real-time
// =========================================================
class LogActivityNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  LogActivityNotifier(this.ref) : super(const AsyncValue.data(null));

  /// Method untuk membuat log activity baru
  /// 
  /// Parameter:
  /// - [title]: Deskripsi aktivitas yang dilakukan
  /// - [userId]: ID user yang melakukan aktivitas (opsional)
  /// 
  /// Contoh penggunaan:
  /// ```dart
  /// await ref.read(logActivityNotifierProvider.notifier).createLog(
  ///   title: 'Menambahkan warga baru: John Doe',
  ///   userId: currentUserId,
  /// );
  /// ```
  Future<void> createLog({
    required String title,
    String? userId,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final client = ref.read(supabaseClientProviderForLog);
      
      // Insert log ke database
      await client.from('log_activity').insert({
        'title': title,
        'user_id': userId,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Refresh log activity list setelah insert berhasil
      ref.invalidate(logActivityListProvider);
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      // Tetap throw error agar caller bisa handle
      throw Exception('Gagal membuat log activity: $e');
    }
  }

  /// Method untuk membuat log activity dengan mendapatkan user_id otomatis
  /// dari session Supabase yang sedang login
  /// 
  /// Parameter:
  /// - [title]: Deskripsi aktivitas yang dilakukan
  /// 
  /// Contoh penggunaan:
  /// ```dart
  /// await ref.read(logActivityNotifierProvider.notifier).createLogWithCurrentUser(
  ///   title: 'Mengedit data warga: Jane Doe',
  /// );
  /// ```
  Future<void> createLogWithCurrentUser({
    required String title,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final client = ref.read(supabaseClientProviderForLog);
      
      // Dapatkan user_id dari session yang sedang login
      final userId = client.auth.currentUser?.id;
      
      // Insert log ke database
      await client.from('log_activity').insert({
        'title': title,
        'user_id': userId,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Refresh log activity list setelah insert berhasil
      ref.invalidate(logActivityListProvider);
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      // Tetap throw error agar caller bisa handle
      throw Exception('Gagal membuat log activity: $e');
    }
  }
}

// Provider untuk LogActivityNotifier
final logActivityNotifierProvider = StateNotifierProvider<LogActivityNotifier, AsyncValue<void>>((ref) {
  return LogActivityNotifier(ref);
});


