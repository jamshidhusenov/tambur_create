import 'package:tambur_create/features/login/domain/entities/user.dart';

class UserModel implements User {
  @override
  final String access;
  @override
  final String refresh;

  UserModel({required this.access, required this.refresh});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(access: json['access'], refresh: json['refresh']);
  }
}
