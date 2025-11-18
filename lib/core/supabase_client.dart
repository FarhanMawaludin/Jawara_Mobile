import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientSingleton {
  static final SupabaseClientSingleton _instance = SupabaseClientSingleton._();
  late final SupabaseClient client;
  SupabaseClientSingleton._() {
    client = Supabase.instance.client;
  }
  factory SupabaseClientSingleton() => _instance;
}
