import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tambur_create/features/login/domain/use_cases/login_user_use_case.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUserUseCase loginUserUseCase;

  LoginBloc({required this.loginUserUseCase}) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      try {
        emit(LoginLoading());
        final request = await loginUserUseCase(
          event.phoneNumber,
          event.password,
        );

        await request.fold(
          (failure) async {
            if (!emit.isDone) {
              emit(LoginFailure(failure.message));
              emit(LoginInitial());
            }
          },
          (user) async {
            await loginUserUseCase.saveAccessToken(user.access, user.refresh);
            if (!emit.isDone) {
              emit(LoginSuccess(user.access));
            }
          },
        );
      } catch (e) {
        if (!emit.isDone) {
          emit(LoginFailure(e.toString()));
          emit(LoginInitial());
        }
      }
    });
  }
}
