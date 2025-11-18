import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/sign_out.dart';     // <= TAMBAHAN
import '../../domain/repositories/auth_repository.dart';

import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';


// =============================
// SUPABASE CLIENT
// =============================
final supabaseClientProvider = Provider<supa.SupabaseClient>((ref) {
  return supa.Supabase.instance.client;
});


// =============================
// REMOTE DATASOURCE
// =============================
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthRemoteDataSourceImpl(supabase);
});


// =============================
// REPOSITORY
// =============================
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remote);
});


// =============================
// USE CASES
// =============================
final loginUseCaseProvider = Provider<Login>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return Login(repo);
});

final signOutUseCaseProvider = Provider<SignOut>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignOut(repo);
});


// =============================
// AUTH CONTROLLER + STATE
// =============================
class AuthState {
  final bool loading;
  final String? error;
  final User? user;

  const AuthState({
    this.loading = false,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? loading,
    String? error,
    User? user,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      error: error,
      user: user ?? this.user,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final loginUseCase = ref.read(loginUseCaseProvider);
      final user = await loginUseCase(
        LoginParams(email: email, password: password),
      );

      state = state.copyWith(loading: false, user: user);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(loading: true, error: null);

    try {
      final signOutUseCase = ref.read(signOutUseCaseProvider);
      await signOutUseCase();

      state = const AuthState();        // Reset state
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
