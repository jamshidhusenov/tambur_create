part of 'otk_bloc.dart';

sealed class OtkState extends Equatable {
  const OtkState();
}

class OtkInitial extends OtkState {
  @override
  List<Object?> get props => [];
}

class OtkLoading extends OtkState {
  @override
  List<Object?> get props => [];
}

class OtkSuccess extends OtkState {
  final ListTamburModel listTambur;
  final List<BrandEntity>? brands;

  const OtkSuccess({
    required this.listTambur,
    this.brands,
  });

  // copyWith
  OtkSuccess copyWith({
    ListTamburModel? listTambur,
    List<BrandEntity>? brands,
  }) {
    return OtkSuccess(
      listTambur: listTambur ?? this.listTambur,
      brands: brands ?? this.brands,
    );
  }

  @override
  List<Object?> get props => [
    listTambur,
    brands,
  ];
}

class OtkFailure extends OtkState {
  final String error;

  const OtkFailure(this.error);

  @override
  List<Object?> get props => [error];
}
