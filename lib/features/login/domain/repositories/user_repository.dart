import 'package:dartz/dartz.dart';
import 'package:tambur_create/core/error/failure.dart';
import 'package:tambur_create/features/login/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> loginUser(String phoneNumber, String password);
}
