import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import 'login_usecase_provider.dart';
import '../../domain/usecases/login.dart';

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
      error: error ?? this.error,
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
      final usecase = ref.read(loginUseCaseProvider);
      final user = await usecase(
        LoginParams(email: email, password: password),
      );

      state = state.copyWith(
        loading: false,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
    }
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
