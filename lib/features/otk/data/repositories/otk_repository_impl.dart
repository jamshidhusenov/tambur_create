import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:tambur_create/core/error/exceptions.dart';
import 'package:tambur_create/core/error/failure.dart';
import 'package:tambur_create/core/services/logger_service.dart';
import 'package:tambur_create/features/otk/data/data_sources/otk_remote_data_source.dart';
import 'package:tambur_create/features/otk/data/model/list_tambur_model.dart';
import 'package:tambur_create/features/otk/domain/repositories/otk_repository.dart';

class OtkRepositoryImpl implements OtkRepository {
  final OtkRemoteDataSource dataSource;

  OtkRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, ListTamburModel>> getListTambur() {
    return dataSource.getListTambur().then((value) {
      if (value.statusCode == 200) {
        final wastePaper = listTamburModelFromJson(value.body);
        return Right(wastePaper);
      } else {
        return Left(
          ServerFailure(
            message: value.body,
            statusCode: value.statusCode,
            errorText: value.body,
          ),
        );
      }
    });
  }

 @override
Future<Either<Failure, bool>> updateTambur({
  required int tamburId,
  required String shift,
  required int radius,
  required int format,
}) async {
  try {
    LoggerService.d('updateTambur');

    final response = await dataSource.updateTambur(
      tamburId: tamburId,
      shift: shift,
      radius: radius,
      format: format,
    );

    LoggerService.d(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return const Right(true);
    } else {
      return Left(
        ServerFailure(
          message: response.body,
          statusCode: response.statusCode,
          errorText: response.body,
        ),
      );
    }
  } on ServerException catch (e) {
    // 🔥 Seni loglarda ko‘rgan "Instance of ServerException" shu joyga tushadi
    return Left(
      ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorText: e.errorText ?? '',
      ),
    );
  } catch (e) {
    return Left(
      ServerFailure(
        message: 'Server xatosi yuz berdi: $e',
        statusCode: 500,
        errorText: e.toString(),
      ),
    );
  }
}


  @override
  Future<Either<Failure, Tambur>> createTambur() {
    return dataSource.createTambur().then((value) {
      if (value.statusCode == 200 || value.statusCode == 201) {
        final tambur = tamburFromString(value.body);
        return Right(tambur);
      } else {
        return Left(
          ServerFailure(
            message: value.statusCode.toString(),
            statusCode: value.statusCode,
            errorText: value.statusCode.toString(),
          ),
        );
      }
    });
  }

  @override
  Future<Either<Failure, bool>> updateWastePaper(
    int id,
    int? percent,
    int? weight,
    String? comment,
    XFile? carImage,
  ) {
    return dataSource
        .updateWastePaper(
          id: id,
          percent: percent,
          weight: weight,
          comment: comment,
          carImage: carImage,
        )
        .then((value) {
          if (value.statusCode == 200 || value.statusCode == 201) {
            return const Right(true);
          } else {
            return Left(
              ServerFailure(
                message: value.statusCode.toString(),
                statusCode: value.statusCode,
                errorText: value.statusCode.toString(),
              ),
            );
          }
        });
  }
}
