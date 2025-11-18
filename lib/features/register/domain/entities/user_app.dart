// lib/domain/entities/user_app.dart
class UserApp {
  final String id;
  final String role;
  final DateTime createdAt;

  UserApp({
    required this.id,
    required this.role,
    required this.createdAt,
  });
}