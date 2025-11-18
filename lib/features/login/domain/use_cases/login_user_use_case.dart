import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tambur_create/core/error/failure.dart';
import 'package:tambur_create/features/login/domain/entities/user.dart';
import 'package:tambur_create/features/login/domain/repositories/user_repository.dart';

class LoginUserUseCase {
  final UserRepository repository;

  LoginUserUseCase(this.repository);

  Future<Either<Failure, User>> call(
    String phoneNumber,
    String password,
  ) async {
    return await repository.loginUser(phoneNumber, password);
  }

  Future<void> saveAccessToken(String accessToken, String refreshToken) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: "accessToken", value: accessToken);
    await storage.write(key: "refreshToken", value: refreshToken);
    final login = Hive.box('login');
    login.put('logged', 1);
  }

  Future<String> getAccessToken() async {
    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: "accessToken");
    return value ?? "access token not found";
  }
}
