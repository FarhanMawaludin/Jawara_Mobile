import '../entities/user.dart';

abstract class AuthRepository {
  /// Melakukan login menggunakan email & password melalui Supabase.
  /// 
  /// Mengembalikan entity `User` yang berisi:
  /// - id (String, UUID dari Supabase)
  /// - email
  /// - token (access token dari Supabase)
  Future<User> login(String email, String password);
  Future<void> signOut(); 
}

