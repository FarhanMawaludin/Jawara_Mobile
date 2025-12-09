import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:jawaramobile/features/aspirasi/data/repositories/aspiration_repository_impl.dart';
import 'package:jawaramobile/features/aspirasi/data/datasources/aspiration_remote_datasource.dart';
import 'package:jawaramobile/features/aspirasi/data/models/aspiration_model.dart';

class MockRemoteDataSource extends Mock implements AspirationRemoteDataSource {}

void main() {
  late MockRemoteDataSource mockRemote;
  late AspirationRepositoryImpl repositoryImpl;

  setUp(() {
    mockRemote = MockRemoteDataSource();
    repositoryImpl = AspirationRepositoryImpl(mockRemote);
  });

  final tModels = [
    AspirationModel(
      id: 1,
      sender: 'u1',
      title: 'T1',
      status: 'Pending',
      createdAt: DateTime.parse('2023-01-01T12:00:00Z'),
      message: 'M1',
    ),
    AspirationModel(
      id: 2,
      sender: 'u2',
      title: 'T2',
      status: 'Done',
      createdAt: DateTime.parse('2023-02-01T12:00:00Z'),
      message: 'M2',
    ),
  ];

  test('should return list of aspirations when remote datasource succeeds', () async {
    // arrange
    when(() => mockRemote.getAllAspirations()).thenAnswer((_) async => tModels);

    // act
    final result = await repositoryImpl.getAllAspirations();

    // assert
    expect(result, tModels);
    verify(() => mockRemote.getAllAspirations()).called(1);
  });

  test('should throw when remote datasource throws', () async {
    // arrange
    when(() => mockRemote.getAllAspirations()).thenThrow(Exception('fail'));

    // act & assert
    expect(() => repositoryImpl.getAllAspirations(), throwsA(isA<Exception>()));
    verify(() => mockRemote.getAllAspirations()).called(1);
  });
}
