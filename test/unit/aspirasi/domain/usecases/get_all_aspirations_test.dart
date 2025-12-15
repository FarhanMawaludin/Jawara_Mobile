import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:jawaramobile/features/aspirasi/domain/usecases/get_all_aspirations.dart';
import 'package:jawaramobile/features/aspirasi/domain/entities/aspiration.dart';
import 'package:jawaramobile/features/aspirasi/domain/repositories/aspiration_repository.dart';

class MockAspirationRepository extends Mock implements AspirationRepository {}

void main() {
  late MockAspirationRepository mockRepository;
  late GetAllAspirations usecase;

  setUp(() {
    mockRepository = MockAspirationRepository();
    usecase = GetAllAspirations(mockRepository);
  });

  final tAspirations = [
    Aspiration(
      id: 1,
      sender: 'user1',
      title: 'Judul 1',
      status: 'Pending',
      createdAt: DateTime.parse('2023-01-01T12:00:00Z'),
      message: 'Pesan 1',
    ),
    Aspiration(
      id: 2,
      sender: 'user2',
      title: 'Judul 2',
      status: 'Done',
      createdAt: DateTime.parse('2023-02-01T12:00:00Z'),
      message: 'Pesan 2',
    ),
  ];

  test('should call repository.getAllAspirations() and return list on success', () async {
    // arrange
    when(() => mockRepository.getAllAspirations())
        .thenAnswer((_) async => tAspirations);

    // act
    final result = await usecase();

    // assert
    expect(result, tAspirations);
    verify(() => mockRepository.getAllAspirations()).called(1);
  });

  test('should throw when repository throws', () async {
    // arrange
    when(() => mockRepository.getAllAspirations())
        .thenThrow(Exception('Gagal'));

    // act & assert
    expect(() => usecase(), throwsA(isA<Exception>()));
    verify(() => mockRepository.getAllAspirations()).called(1);
  });
}
