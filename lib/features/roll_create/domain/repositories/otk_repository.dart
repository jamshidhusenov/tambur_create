import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tambur_create/core/error/failure.dart';
import 'package:tambur_create/features/roll_create/data/model/list_tambur_model.dart';
import 'package:tambur_create/features/roll_create/domain/entities/brand_entity.dart';

abstract class OtkRepository {
  Future<Either<Failure, ListTamburModel>> getListTambur();
  Future<Either<Failure, Tambur>> createTambur();
  Future<Either<Failure, bool>> updateTambur({
    required int tamburId,
    required String shift,
    required int radius,
    required int format,
    int? brand,
  });
  Future<Either<Failure, bool>> updateWastePaper(
    int id,
    int? percent,
    int? weight,
    String? comment,
    XFile? carImage,
  );
  Future<Either<Failure, List<BrandEntity>>> getBrands();
}
