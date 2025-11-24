class Aspiration {
  final int? id;
  final String sender;
  final String title;
  final String status;
  final DateTime createdAt;
  final String message;

  Aspiration({
    this.id,
    required this.sender,
    required this.title,
    required this.status,
    required this.createdAt,
    required this.message,
  });
}
