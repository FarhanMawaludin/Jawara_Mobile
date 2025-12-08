import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/usecases/rumah/update_rumah.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jawaramobile/features/warga/domain/entities/rumah.dart';
import 'package:jawaramobile/features/warga/domain/repositories/rumah_repository.dart';

// Mock
class MockRumahRepository extends Mock implements RumahRepository {}

// Fake (Wajib untuk any())
class FakeRumah extends Fake implements Rumah {}

void main() {
  late MockRumahRepository mockRepository;
  late UpdateRumah usecase;

  setUpAll(() {
    registerFallbackValue(FakeRumah());
  });

  setUp(() {
    mockRepository = MockRumahRepository();
    usecase = UpdateRumah(mockRepository);
  });

  final rumah = Rumah(
    id: 1,
    keluargaId: 12,
    blok: "A",
    nomorRumah: "10",
    alamatLengkap: "Jl. Melati No. 10",
    createdAt: DateTime.now(),
  );

  test("UpdateRumah memanggil repository.updateRumah(rumah)", () async {
    when(() => mockRepository.updateRumah(any())).thenAnswer((_) async {});

    await usecase(rumah);

    verify(() => mockRepository.updateRumah(rumah)).called(1);
  });
}
