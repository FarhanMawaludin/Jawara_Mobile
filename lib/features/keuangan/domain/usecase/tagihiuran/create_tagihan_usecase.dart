import '../../repositories/tagihiuran_repository.dart';

class CreateTagihanUsecase {
  final TagihIuranRepository repository;

  CreateTagihanUsecase(this.repository);

  Future<void> call({
    required int kategoriId,
    required String nama,
    required int jumlah,
  }) async {
    // Bisa tambahkan validasi bisnis logic di sini
    if (nama.trim().isEmpty) {
      throw Exception('Nama iuran tidak boleh kosong');
    }

    if (jumlah < 0) {
      throw Exception('Jumlah tidak boleh negatif');
    }

    await repository.createTagihanForAllKeluarga(
      kategoriId: kategoriId,
      nama: nama,
      jumlah: jumlah,
    );
  }
}