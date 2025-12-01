import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/entities/rumah.dart';
import 'package:jawaramobile/features/warga/domain/repositories/rumah_repository.dart';
import 'package:jawaramobile/features/warga/domain/usecases/rumah/create_rumah.dart';
import 'package:mocktail/mocktail.dart';


class MockRumahRepository extends Mock implements RumahRepository {}

void main() {
  late MockRumahRepository mockRepository;
  late CreateRumah usecase;

  setUp(() {
    mockRepository = MockRumahRepository();
    usecase = CreateRumah(mockRepository);
  });

  test('should call repository.createRumah correctly', () async {
    final rumah = Rumah(
      id: 1,
      keluargaId: 12,
      blok: "A",
      nomorRumah: "10",
      alamatLengkap: "Jl. Melati No. 10",
      createdAt: DateTime.now(),
    );

    when(() => mockRepository.createRumah(rumah))
        .thenAnswer((_) async => Future.value());

    await usecase(rumah);

    verify(() => mockRepository.createRumah(rumah)).called(1);
  });
}
