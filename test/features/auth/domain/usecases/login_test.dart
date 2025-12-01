import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:jawaramobile/features/auth/domain/usecases/login.dart';
import 'package:jawaramobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:jawaramobile/features/auth/domain/entities/user.dart';

import 'login_test.mocks.dart';

// Generate mock untuk AuthRepository
@GenerateMocks([AuthRepository])
void main() {
  late Login usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = Login(mockAuthRepository);
  });

  group('Login UseCase', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testUser = User(
      id: '123',
      email: testEmail,
      token: 'fake-token-123',
    );

    test('should return User from repository when login is successful', () async {
      // Arrange
      when(mockAuthRepository.login(any, any))
          .thenAnswer((_) async => testUser);

      // Act
      final result = await usecase(
        LoginParams(email: testEmail, password: testPassword),
      );

      // Assert
      expect(result, testUser);
      expect(result.email, testEmail);
      expect(result.id, '123');
      expect(result.token, 'fake-token-123');
      
      // Verify repository method was called with correct parameters
      verify(mockAuthRepository.login(testEmail, testPassword)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should throw exception when repository throws exception', () async {
      // Arrange
      when(mockAuthRepository.login(any, any))
          .thenThrow(Exception('Invalid credentials'));

      // Act & Assert
      expect(
        () => usecase(LoginParams(email: testEmail, password: testPassword)),
        throwsException,
      );
      
      verify(mockAuthRepository.login(testEmail, testPassword)).called(1);
    });

    test('should throw exception when email is invalid', () async {
      // Arrange
      const invalidEmail = 'invalid-email';
      when(mockAuthRepository.login(any, any))
          .thenThrow(Exception('Invalid email format'));

      // Act & Assert
      expect(
        () => usecase(LoginParams(email: invalidEmail, password: testPassword)),
        throwsException,
      );
    });

    test('should throw exception when password is wrong', () async {
      // Arrange
      const wrongPassword = 'wrongpassword';
      when(mockAuthRepository.login(any, any))
          .thenThrow(Exception('Wrong password'));

      // Act & Assert
      expect(
        () => usecase(LoginParams(email: testEmail, password: wrongPassword)),
        throwsException,
      );
      
      verify(mockAuthRepository.login(testEmail, wrongPassword)).called(1);
    });

    test('should throw exception when network error occurs', () async {
      // Arrange
      when(mockAuthRepository.login(any, any))
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => usecase(LoginParams(email: testEmail, password: testPassword)),
        throwsException,
      );
    });

    test('should call repository.login exactly once', () async {
      // Arrange
      when(mockAuthRepository.login(any, any))
          .thenAnswer((_) async => testUser);

      // Act
      await usecase(LoginParams(email: testEmail, password: testPassword));

      // Assert
      verify(mockAuthRepository.login(testEmail, testPassword)).called(1);
    });

    test('should handle empty email', () async {
      // Arrange
      const emptyEmail = '';
      when(mockAuthRepository.login(any, any))
          .thenThrow(Exception('Email cannot be empty'));

      // Act & Assert
      expect(
        () => usecase(LoginParams(email: emptyEmail, password: testPassword)),
        throwsException,
      );
    });

    test('should handle empty password', () async {
      // Arrange
      const emptyPassword = '';
      when(mockAuthRepository.login(any, any))
          .thenThrow(Exception('Password cannot be empty'));

      // Act & Assert
      expect(
        () => usecase(LoginParams(email: testEmail, password: emptyPassword)),
        throwsException,
      );
    });

    test('should handle session null from repository', () async {
      // Arrange
      when(mockAuthRepository.login(any, any))
          .thenThrow(Exception('Login gagal: session atau user tidak ditemukan'));

      // Act & Assert
      expect(
        () => usecase(LoginParams(email: testEmail, password: testPassword)),
        throwsException,
      );
    });
  });
}