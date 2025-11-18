// lib/domain/usecases/register_account.dart
import '../entities/user_app.dart';
import '../repositories/register_repository.dart';

class RegisterAccount {
  final RegisterRepository repository;

  RegisterAccount(this.repository);

  Future<UserApp> execute(String email, String password) {
    return repository.registerAccount(email, password);
  }
}