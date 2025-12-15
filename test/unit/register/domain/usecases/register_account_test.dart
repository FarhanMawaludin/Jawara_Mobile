import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:jawaramobile/features/register/domain/usecases/register_account.dart';
import 'package:jawaramobile/features/register/domain/repositories/register_repository.dart';

class MockRegisterRepository extends Mock implements RegisterRepository {}

void main() {
  late MockRegisterRepository repository;
  late RegisterAccount usecase;

  setUp(() {
    repository = MockRegisterRepository();
    usecase = RegisterAccount(repository);
  });

  const email = "test@email.com";
  const password = "123456";

  test("should return success message when registerAccount is successful", () async {
    // arrange
    when(() => repository.registerAccount(email, password))
        .thenAnswer((_) async => "Register Success");

    // act
    final result = await usecase(email, password);

    // assert
    expect(result, "Register Success");
    verify(() => repository.registerAccount(email, password)).called(1);
  });

  test("should throw exception when repository throws error", () async {
    // arrange
    when(() => repository.registerAccount(email, password))
        .thenThrow(Exception("Failed to register"));

    // act & assert
    expect(
      () => usecase(email, password),
      throwsA(isA<Exception>()),
    );

    verify(() => repository.registerAccount(email, password)).called(1);
  });
}
