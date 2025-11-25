// lib/data/models/user_app_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_app.dart';

part 'user_app_model.g.dart';

@JsonSerializable()
class UserAppModel extends UserApp {

  UserAppModel({
    required super.id,
    required super.role,
    @JsonKey(name: 'created_at') required super.createdAt,
  });

  factory UserAppModel.fromJson(Map<String, dynamic> json) =>
      _$UserAppModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserAppModelToJson(this);
}
