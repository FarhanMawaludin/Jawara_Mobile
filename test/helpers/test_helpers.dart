import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../lib/config/app_config.dart';

class TestHelpers {
  static bool _isInitialized = false;

  /// Initialize Supabase for testing
  static Future<void> initializeSupabase() async {
    if (_isInitialized) return;

    // ✅ IMPORTANT: Initialize Flutter test binding first
    TestWidgetsFlutterBinding.ensureInitialized();

    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );

    _isInitialized = true;
  }

  /// Get Supabase client instance
  static SupabaseClient getSupabaseClient() {
    if (!_isInitialized) {
      throw Exception(
        'Supabase belum diinisialisasi. Panggil TestHelpers.initializeSupabase() terlebih dahulu.',
      );
    }
    return Supabase.instance.client;
  }

  /// Reset Supabase (untuk cleanup setelah test)
  static void resetSupabase() {
    _isInitialized = false;
  }

  /// Create mock response helper
  static Map<String, dynamic> createMockResponse({
    required bool success,
    String? message,
    dynamic data,
    Map<String, dynamic>? errors,
  }) {
    return {
      'success': success,
      if (message != null) 'message': message,
      if (data != null) 'data': data,
      if (errors != null) 'errors': errors,
    };
  }

  /// Create pagination response helper
  static Map<String, dynamic> createPaginationResponse({
    required List<dynamic> data,
    required int total,
    int limit = 10,
    int offset = 0,
  }) {
    return {
      'success': true,
      'data': data,
      'total': total,
      'limit': limit,
      'offset': offset,
    };
  }
}