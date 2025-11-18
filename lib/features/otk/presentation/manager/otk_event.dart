part of 'otk_bloc.dart';

sealed class OtkEvent extends Equatable {
  const OtkEvent();
}

class GetListTamburEvent extends OtkEvent {
  const GetListTamburEvent();

  @override
  List<Object?> get props => [];
} 

class UpdateWastePaperEvent extends OtkEvent {
  final int id;
  final int? percent;
  final int? weight;
  final String? comment;
  final Function() onSuccess;
  final Function(String error) onError;
  final XFile? carImage;
  const UpdateWastePaperEvent({required this.id, this.percent, this.weight, this.comment, 
  required this.onSuccess, required this.onError, this.carImage});

  @override
  List<Object?> get props => [id, percent, weight, comment, onSuccess, onError, carImage];
}

class CreateTamburEvent extends OtkEvent {
  final Function(Tambur) onSuccess;
  final Function(String error) onError;
  const CreateTamburEvent({required this.onSuccess, required this.onError});

  @override
  List<Object?> get props => [onSuccess, onError];
}

class UpdateTamburEvent extends OtkEvent {
  final int tamburId;
  final String shift;
  final int radius;
  final int format;
  final Function() onSuccess;
  final Function(String error) onError;
  const UpdateTamburEvent({required this.tamburId, required this.shift, required this.radius, required this.format, 
  required this.onSuccess, required this.onError});

  @override
  List<Object?> get props => [tamburId, shift, radius, format, onSuccess, onError];
}



