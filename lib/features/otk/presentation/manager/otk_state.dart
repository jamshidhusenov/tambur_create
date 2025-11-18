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
  final ListTamburModel listTambur  ;

  const OtkSuccess({
    required this.listTambur,
  });

  // copyWith
  OtkSuccess copyWith({
    ListTamburModel? listTambur,
  }) {
    return OtkSuccess(
      listTambur: listTambur ?? this.listTambur,
    );
  }

  @override
  List<Object?> get props => [
    listTambur,
  ];
  
}

class OtkFailure extends OtkState {
  final String error;

  const OtkFailure(this.error);

  @override
  List<Object?> get props => [error];
}
