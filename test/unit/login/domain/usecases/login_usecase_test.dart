import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:jawaramobile/features/auth/domain/usecases/login.dart';
import 'package:jawaramobile/features/auth/domain/entities/user.dart';
import 'package:jawaramobile/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late Login loginUsecase;

  setUp(() {
    repository = MockAuthRepository();
    loginUsecase = Login(repository);
  });

  const params = LoginParams(email: "test@email.com", password: "123456");

  test("should call repository.login() and return User on success", () async {
    // arrange
    final user = User(id: '1', email: "test@email.com");

    when(
      () => repository.login(params.email, params.password),
    ).thenAnswer((_) async => user);

    // act
    final result = await loginUsecase(params);

    // assert
    expect(result, user);
    verify(() => repository.login(params.email, params.password)).called(1);
  });

  test("should throw exception when repository throws error", () async {
    // arrange
    when(
      () => repository.login(params.email, params.password),
    ).thenThrow(Exception("Invalid credentials"));

    // act & assert
    expect(() => loginUsecase(params), throwsA(isA<Exception>()));

    verify(() => repository.login(params.email, params.password)).called(1);
  });
}
