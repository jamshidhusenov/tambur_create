import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:tambur_create/core/error/exceptions.dart';
import 'package:tambur_create/core/error/failure.dart';
import 'package:tambur_create/core/services/logger_service.dart';
import 'package:tambur_create/features/login/data/data_sources/user_remote_data_source.dart';
import 'package:tambur_create/features/login/data/models/user_model.dart';
import 'package:tambur_create/features/login/domain/entities/user.dart';
import 'package:tambur_create/features/login/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource dataSource;

  UserRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, User>> loginUser(
    String phoneNumber,
    String password,
  ) async {
    try {
      final response = await dataSource.loginUser(phoneNumber, password);
      if (response.statusCode == 200) {
        LoggerService.i(response.body);
        UserModel userModel = UserModel.fromJson(jsonDecode(response.body));
        return Right(userModel);
      } else {
        LoggerService.i(response.body);

        return Left(
          ServerFailure(
            message: response.body,
            statusCode: response.statusCode,
            errorText: response.body,
          ),
        );
      }
    } on TimeoutException {
      return const Left(
        ServerFailure(
          message: 'Sorov vaqti tugadi',
          statusCode: 408,
          errorText: 'Request timeout',
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
          errorText: e.errorText,
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(
          message: "${e}2",
          statusCode: 500,
          errorText: e.toString(),
        ),
      );
    }
  }
}
