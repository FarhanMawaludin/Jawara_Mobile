class BroadcastModel {
  final int id;
  final String? judulBroadcast;
  final String? isiBroadcast;
  final String? fotoBroadcast;
  final String? dokumenBroadcast;
  final DateTime? createdAt;

  BroadcastModel({
    required this.id,
    this.judulBroadcast,
    this.isiBroadcast,
    this.fotoBroadcast,
    this.dokumenBroadcast,
    this.createdAt,
  });

  factory BroadcastModel.fromJson(Map<String, dynamic> json) {
    return BroadcastModel(
      id: json['id'] as int,
      judulBroadcast: json['judul_broadcast'] as String?,
      isiBroadcast: json['isi_broadcast'] as String?,
      fotoBroadcast: json['foto_broadcast'] as String?,
      dokumenBroadcast: json['dokumen_broadcast'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul_broadcast': judulBroadcast,
      'isi_broadcast': isiBroadcast,
      'foto_broadcast': fotoBroadcast,
      'dokumen_broadcast': dokumenBroadcast,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

class BroadcastFormModel {
  final String judul;
  final String isi;
  final String? fotoPath;
  final String? dokumenPath;

  BroadcastFormModel({
    this.judul = '',
    this.isi = '',
    this.fotoPath,
    this.dokumenPath,
  });

  BroadcastFormModel copyWith({
    String? judul,
    String? isi,
    String? fotoPath,
    String? dokumenPath,
  }) {
    return BroadcastFormModel(
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      fotoPath: fotoPath ?? this.fotoPath,
      dokumenPath: dokumenPath ?? this.dokumenPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judul_broadcast': judul,
      'isi_broadcast': isi,
      'foto_broadcast': fotoPath,
      'dokumen_broadcast': dokumenPath,
    };
  }

  factory BroadcastFormModel.fromJson(Map<String, dynamic> json) {
    return BroadcastFormModel(
      judul: json['judul_broadcast'] as String? ?? '',
      isi: json['isi_broadcast'] as String? ?? '',
      fotoPath: json['foto_broadcast'] as String?,
      dokumenPath: json['dokumen_broadcast'] as String?,
    );
  }

  bool get isValid => judul.isNotEmpty && isi.isNotEmpty;

  bool get isEmpty =>
      judul.isEmpty && isi.isEmpty && fotoPath == null && dokumenPath == null;

  bool get isNotEmpty => !isEmpty;

  @override
  String toString() {
    return 'BroadcastFormModel(judul: $judul, isi: $isi, fotoPath: $fotoPath, dokumenPath: $dokumenPath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BroadcastFormModel &&
        other.judul == judul &&
        other.isi == isi &&
        other.fotoPath == fotoPath &&
        other.dokumenPath == dokumenPath;
  }

  @override
  int get hashCode {
    return judul.hashCode ^
        isi.hashCode ^
        fotoPath.hashCode ^
        dokumenPath.hashCode;
  }
}