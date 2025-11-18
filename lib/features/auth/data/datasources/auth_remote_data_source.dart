import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> signIn(String email, String password);
  Future<AuthResponse> signUp(String email, String password);
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabase;

  AuthRemoteDataSourceImpl(this.supabase);

  @override
  Future<AuthResponse> signIn(String email, String password) async {
    final res = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return res;
  }

  @override
  Future<AuthResponse> signUp(String email, String password) async {
    final res = await supabase.auth.signUp(
      email: email,
      password: password,
    );
    return res;
  }

  @override
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
