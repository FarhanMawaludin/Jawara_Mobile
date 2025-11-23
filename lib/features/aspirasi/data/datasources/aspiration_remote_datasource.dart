import 'package:supabase_flutter/supabase_flutter.dart';
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
        final List<dynamic> aspirasiRaw = await client
            .from('aspirasi')
            .select()
            .order('created_at', ascending: false) as List<dynamic>;

        // No server-side join to auth.users here (auth.users is not
        // queryable from the client by default). Map aspirasi rows directly
        // and let AspirationModel fallback to showing a shortened user_id
        // when no user.email is available.
        final mapped = aspirasiRaw.map((e) {
          final row = Map<String, dynamic>.from(e as Map<String, dynamic>);
          return AspirationModel.fromMap(row);
        }).toList();

        return mapped;
    } catch (e) {
      throw Exception('Gagal mengambil data aspirasi: $e');
    }
  }
}
