import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/login.dart';
import 'auth_repository_provider.dart';

final loginUseCaseProvider = Provider<Login>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return Login(repo);
});
