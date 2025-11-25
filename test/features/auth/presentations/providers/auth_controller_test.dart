import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// lib importing
import 'package:jawaramobile/features/auth/presentations/providers/auth_controller.dart';
import 'package:jawaramobile/features/auth/presentations/providers/login_usecase_provider.dart';
import 'package:jawaramobile/features/auth/domain/usecases/login.dart';
import 'package:jawaramobile/features/auth/domain/entities/user.dart';

// Import mocking
import 'auth_controller_test.mocks.dart';


@GenerateMocks([Login])
void main() {
  late MockLogin mockLoginUseCase;
  late ProviderContainer container;

  setUp(() {
    mockLoginUseCase = MockLogin();
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthController', () {
    test('initial state should be empty', () {
      container = ProviderContainer(
        overrides: [
          loginUseCaseProvider.overrideWithValue(mockLoginUseCase),
        ],
      );
      
      final state = container.read(authControllerProvider);
      
      expect(state.loading, false);
      expect(state.error, null);
      expect(state.user, null);
    });

    test('login should update state to loading then success', () async {
      // Arrange
      const user = User(
        id: '123',
        email: 'test@example.com',
        token: 'fake-token-123',
      );
      
      when(mockLoginUseCase.call(any)).thenAnswer((_) async => user);

      container = ProviderContainer(
        overrides: [
          loginUseCaseProvider.overrideWithValue(mockLoginUseCase),
        ],
      );

      // Act
      final controller = container.read(authControllerProvider.notifier);
      final future = controller.login('test@example.com', 'password123');

      // Assert loading
      expect(container.read(authControllerProvider).loading, true);
      
      await future;
      
      
      final finalState = container.read(authControllerProvider);
      expect(finalState.loading, false);
      expect(finalState.error, null);
      expect(finalState.user, user);
      expect(finalState.user?.email, 'test@example.com');
      expect(finalState.user?.id, '123');
      
      verify(mockLoginUseCase.call(
        LoginParams(email: 'test@example.com', password: 'password123'),
      )).called(1);
    });

    test('login should update state with error on failure', () async {
      when(mockLoginUseCase.call(any))
          .thenThrow(Exception('Invalid credentials'));

      container = ProviderContainer(
        overrides: [
          loginUseCaseProvider.overrideWithValue(mockLoginUseCase),
        ],
      );

      final controller = container.read(authControllerProvider.notifier);
      await controller.login('test@example.com', 'wrongpassword');


      final state = container.read(authControllerProvider);
      expect(state.loading, false);
      expect(state.error, contains('Invalid credentials'));
      expect(state.user, null);
    });
  });
}