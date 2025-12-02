class BroadcastModel {
  final int id;
  final String judulBroadcast;
  final String isiBroadcast;
  final String? fotoBroadcast;
  final String? dokumenBroadcast;
  final DateTime? createdAt;

  BroadcastModel({
    required this.id,
    required this.judulBroadcast,
    required this.isiBroadcast,
    this.fotoBroadcast,
    this.dokumenBroadcast,
    this.createdAt,
  });

  factory BroadcastModel.fromJson(Map<String, dynamic> json) {
    return BroadcastModel(
      id: json['id'] as int,
      judulBroadcast: json['judul_broadcast'] as String? ?? '',
      isiBroadcast: json['isi_broadcast'] as String? ?? '',
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

  bool get hasFoto => fotoBroadcast != null && 
      fotoBroadcast!.isNotEmpty && 
      fotoBroadcast != 'NULL';

  bool get hasDokumen => dokumenBroadcast != null && 
      dokumenBroadcast!.isNotEmpty && 
      dokumenBroadcast != 'NULL';

  BroadcastModel copyWith({
    int? id,
    String? judulBroadcast,
    String? isiBroadcast,
    String? fotoBroadcast,
    String? dokumenBroadcast,
    DateTime? createdAt,
  }) {
    return BroadcastModel(
      id: id ?? this.id,
      judulBroadcast: judulBroadcast ?? this.judulBroadcast,
      isiBroadcast: isiBroadcast ?? this.isiBroadcast,
      fotoBroadcast: fotoBroadcast ?? this.fotoBroadcast,
      dokumenBroadcast: dokumenBroadcast ?? this.dokumenBroadcast,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'BroadcastModel(id: $id, judul: $judulBroadcast, isi: $isiBroadcast)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BroadcastModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}