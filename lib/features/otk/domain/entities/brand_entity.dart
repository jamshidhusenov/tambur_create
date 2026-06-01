import 'package:equatable/equatable.dart';

class BrandEntity extends Equatable {
  final int id;
  final String title;

  const BrandEntity({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];
}
