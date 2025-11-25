// lib/domain/usecases/register_account.dart

import '../repositories/register_repository.dart';

class RegisterAccount {
  final RegisterRepository repository;

  RegisterAccount(this.repository);

  Future<String> call(String email, String password) async {
    return repository.registerAccount(email, password);
  }
}
