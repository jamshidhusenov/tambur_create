import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tambur_create/core/error/failure.dart';
import 'package:tambur_create/features/otk/data/model/list_tambur_model.dart';
import 'package:tambur_create/features/otk/domain/repositories/otk_repository.dart';

class OtkUseCase implements OtkRepository {
  final OtkRepository repository;

  OtkUseCase(this.repository);

  @override
  Future<Either<Failure, ListTamburModel>> getListTambur() {
    return repository.getListTambur();
  }

  @override
  Future<Either<Failure, bool>> updateTambur({
    required int tamburId,
    required String shift,
    required int radius,
    required int format,
  }) {
    return repository.updateTambur(tamburId: tamburId, shift: shift, radius: radius, format: format);
  }

  @override
  Future<Either<Failure, Tambur>> createTambur() {
    return repository.createTambur();
  }

  @override
  Future<Either<Failure, bool>> updateWastePaper(
    int id,
    int? percent,
    int? weight,
    String? comment,
    XFile? carImage,
  ) {
    return repository.updateWastePaper(id, percent, weight, comment, carImage);
  }
}
