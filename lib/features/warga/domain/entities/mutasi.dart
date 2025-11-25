
class Mutasi {
  final int id;
  final int? keluargaId;
  final int? rumahId;
  final int? rumahSekarangId;
  final String? jenisMutasi; // ENUM: 'Masuk' | 'Keluar'
  final String? alasanMutasi;
  final DateTime? tanggalMutasi;
  final DateTime createdAt;

  final Map<String, dynamic>? keluarga;
  final Map<String, dynamic>? rumah;

  Mutasi({
    required this.id,
    this.keluargaId,
    this.rumahId,
    this.rumahSekarangId,
    this.jenisMutasi,
    this.alasanMutasi,
    this.tanggalMutasi,
    this.keluarga,
    this.rumah,
    required this.createdAt,
  });
}