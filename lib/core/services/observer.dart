import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tambur_create/core/services/logger_service.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    LoggerService.i("${bloc.runtimeType} $change");
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    LoggerService.i('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}
