part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();
}
class LoginButtonPressed extends LoginEvent {

  final String phoneNumber;
  final String password;

  const LoginButtonPressed({required this.phoneNumber, required this.password});

  @override
  List<Object?> get props => [];
}
