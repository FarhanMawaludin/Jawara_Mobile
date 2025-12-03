import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/aspiration_model.dart';

abstract class AspirationRemoteDataSource {
  Future<List<AspirationModel>> getAllAspirations();
}

class AspirationRemoteDataSourceImpl implements AspirationRemoteDataSource {
  final SupabaseClient client;

  AspirationRemoteDataSourceImpl(this.client);

  @override
  Future<List<AspirationModel>> getAllAspirations() async {
    try {
      // Adjust table name if your table named differently (e.g. 'aspirations')
        // Fetch aspirasi rows first (no join). Some Supabase/PostgREST setups
        // don't expose a foreign-key relationship between 'aspirasi' and
        // 'auth.users', so server-side joins fail. Instead we fetch aspirasi
        // then request matching users from `auth.users` and merge client-side.
        final List<dynamic> aspirasiRaw = await fetchRawAspirasi();

        // No server-side join to auth.users here (auth.users is not
        // queryable from the client by default). Map aspirasi rows directly
        // and let AspirationModel fallback to showing a shortened user_id
        // when no user.email is available.
        final mapped = AspirationRemoteDataSourceImpl.parseRaw(aspirasiRaw);

        return mapped;
    } catch (e) {
      throw Exception('Gagal mengambil data aspirasi: $e');
    }
  }

  // Extracted to a separate method to make the network/query layer
  // easier to mock or override in tests. By default this performs the
  // same supabase query as before.
  @visibleForTesting
  Future<List<dynamic>> fetchRawAspirasi() async {
    return await client.from('aspirasi').select().order('created_at', ascending: false) as List<dynamic>;
  }

  // Exposed helper to parse raw rows from the DB into models.
  // This makes parsing testable without mocking Supabase client chain.
  static List<AspirationModel> parseRaw(List<dynamic> aspirasiRaw) {
    return aspirasiRaw.map((e) {
      final row = Map<String, dynamic>.from(e as Map<String, dynamic>);
      return AspirationModel.fromMap(row);
    }).toList();
  }
}
