class MockData {
  // ============= BROADCAST MOCK DATA =============

  static Map<String, dynamic> broadcastJsonResponse = {
    'success': true,
    'message': 'Broadcast berhasil dibuat',
    'data': {
      'id': 1,
      'judul_broadcast': 'Pengumuman Iuran RT',
      'isi_broadcast': 'Kepada seluruh warga RT 05, diinformasikan bahwa iuran bulan Desember sudah dapat dibayarkan',
      'foto_broadcast': null,
      'dokumen_broadcast': null,
      'created_at': '2025-12-02T10:00:00.000Z',
      'updated_at': '2025-12-02T10:00:00.000Z'
    }
  };

  static Map<String, dynamic> broadcastListResponse = {
    'success': true,
    'data': [
      {
        'id': 1,
        'judul_broadcast': 'Pengumuman Iuran RT',
        'isi_broadcast': 'Iuran bulan Desember sudah dapat dibayarkan',
        'foto_broadcast': null,
        'dokumen_broadcast': null,
        'created_at': '2025-12-02T10:00:00.000Z'
      },
      {
        'id': 2,
        'judul_broadcast': 'Info Posyandu',
        'isi_broadcast': 'Posyandu akan diadakan tanggal 10 Desember',
        'foto_broadcast': null,
        'dokumen_broadcast': null,
        'created_at': '2025-12-01T09:00:00.000Z'
      },
      {
        'id': 3,
        'judul_broadcast': 'Jadwal Ronda',
        'isi_broadcast': 'Jadwal ronda minggu ini sudah tersedia',
        'foto_broadcast': null,
        'dokumen_broadcast': null,
        'created_at': '2025-11-30T08:00:00.000Z'
      }
    ]
  };

  static Map<String, dynamic> deleteBroadcastResponse = {
    'success': true,
    'message': 'Broadcast berhasil dihapus'
  };

  static Map<String, dynamic> validationErrorResponse = {
    'success': false,
    'message': 'Validasi gagal',
    'errors': {
      'judul_broadcast': ['Judul broadcast wajib diisi'],
      'isi_broadcast': ['Isi broadcast minimal 10 karakter']
    }
  };

  static Map<String, dynamic> notFoundResponse = {
    'success': false,
    'message': 'Data tidak ditemukan'
  };

  static Map<String, dynamic> serverErrorResponse = {
    'success': false,
    'message': 'Internal server error'
  };

  // ============= KEGIATAN MOCK DATA =============

  static Map<String, dynamic> kegiatanJsonResponse = {
    'success': true,
    'message': 'Kegiatan berhasil dibuat',
    'data': {
      'id': 1,
      'nama_kegiatan': 'Kerja Bakti Lingkungan',
      'kategori_kegiatan': 'sosial',
      'tanggal_kegiatan': '2025-12-05T00:00:00.000Z',
      'lokasi_kegiatan': 'Kampung Melayu',
      'penanggung_jawab_kegiatan': 'Budi Santoso',
      'deskripsi_kegiatan': 'Kegiatan bersih-bersih lingkungan',
      'created_at': '2025-12-02T10:00:00.000Z',
      'updated_at': '2025-12-02T10:00:00.000Z'
    }
  };
}