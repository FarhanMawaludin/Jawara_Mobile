import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<User> login(String email, String password) async {
    final response = await remote.signIn(email, password);

    final session = response.session;
    final user = response.user;

    if (session == null || user == null) {
      throw Exception('Login gagal: session atau user tidak ditemukan');
    }

    return User(
      id: user.id,                
      email: user.email ?? "",
      token: session.accessToken,  
    );
  }

  @override
  Future<void> signOut() {
    return remote.signOut();
  }
}
