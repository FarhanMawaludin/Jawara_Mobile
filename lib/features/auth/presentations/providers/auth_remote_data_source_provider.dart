import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import 'supabase_provider.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthRemoteDataSourceImpl(supabase);
});
