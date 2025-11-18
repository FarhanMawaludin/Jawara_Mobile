import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    super.token,
  });

  factory UserModel.fromSupabase( supa.User supabaseUser, String? token) {
    return UserModel(
      id: supabaseUser.id,
      email: supabaseUser.email ?? '',
      token: token,
    );
  }
}
