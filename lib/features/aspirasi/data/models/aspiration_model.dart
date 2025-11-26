import '../../domain/entities/aspiration.dart';

class AspirationModel extends Aspiration {

  AspirationModel({
    int? id,
    required String sender,
    required String title,
    required String status,
    required DateTime createdAt,
    required String message,
  }) : super(id: id, sender: sender, title: title, status: status, createdAt: createdAt, message: message);

  factory AspirationModel.fromMap(Map<String, dynamic> map) {
    // Map DB columns from Supabase schema. Use the actual column names seen
    // in your Supabase table: 'judul' and 'deskripsi_aspirasi'. For sender
    // we fallback to the user_id (UUID) if no name is provided.
    final rawSender = map['sender'] ?? map['nama'] ?? map['pengirim'] ?? map['user_id'] ?? '';
    String sender;
    if (rawSender is String && rawSender.isNotEmpty) {
      // If it's a UUID (user_id), show a short form to avoid long text.
      sender = rawSender.length > 8 && rawSender.contains('-') ? rawSender.substring(0, 8) : rawSender;
    } else {
      sender = 'Anon';
    }

    final title = (map['title'] ?? map['judul'] ?? map['subject'] ?? '') as String;
    final status = (map['status'] ?? map['status_aspirasi'] ?? 'Pending') as String;

    // created_at is commonly stored as ISO string or timestamp; try parsing defensively
    DateTime createdAt = DateTime.now();
    final rawCreated = map['created_at'] ?? map['createdAt'] ?? map['tanggal'] ?? map['date'];
    if (rawCreated is String) {
      try {
        createdAt = DateTime.parse(rawCreated);
      } catch (_) {
        createdAt = DateTime.now();
      }
    } else if (rawCreated is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(rawCreated);
    } else if (rawCreated is DateTime) {
      createdAt = rawCreated;
    }

    final message = (map['message'] ?? map['pesan'] ?? map['isi'] ?? map['deskripsi_aspirasi'] ?? '') as String;
    final id = map['id'] is int ? map['id'] as int : (map['id'] is String ? int.tryParse(map['id']) : null);

    return AspirationModel(
      id: id,
      sender: sender,
      title: title,
      status: status,
      createdAt: createdAt,
      message: message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'sender': sender,
      'title': title,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'message': message,
    };
  }
}
