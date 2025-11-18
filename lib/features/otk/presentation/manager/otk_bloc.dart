import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tambur_create/core/ui/dialog_utils.dart';
import 'package:tambur_create/features/otk/data/model/list_tambur_model.dart';
import 'package:tambur_create/features/otk/domain/use_cases/otk_use_case.dart';

part 'otk_event.dart';
part 'otk_state.dart';

/// A BLoC (Business Logic Component) for handling OTK related operations.
///
/// This BLoC manages the state for OTK forms, data fetching, and roll creation operations.
/// It handles events like [CreateRollEvent] and [GetOtkFieldsEvent], and emits
/// appropriate states based on operation results.
class OtkBloc extends Bloc<OtkEvent, OtkState> {
  final OtkUseCase _otkUseCase;

  OtkBloc({required OtkUseCase otkUseCase})
    : _otkUseCase = otkUseCase,
      super(OtkInitial()) {
    // Register event handlers
    on<GetListTamburEvent>(_onGetListTambur);
    on<UpdateWastePaperEvent>(_onUpdateWastePaper);
    on<CreateTamburEvent>(_onCreateTambur);
    on<UpdateTamburEvent>(_onUpdateTambur);
  }

  Future<void> _onGetListTambur(
    GetListTamburEvent event,
    Emitter<OtkState> emit,
  ) async {
    emit(OtkLoading());
    final result = await _otkUseCase.getListTambur();

    result.fold(
      (failure) {
        emit(OtkInitial());
        DialogUtils.showErrorToast(failure.message);
      },
      (success) {
        // Use copyWith to preserve existing order data if available
        final currentState = state;
        if (currentState is OtkSuccess) {
          emit(currentState.copyWith(listTambur: success));
        } else {
          emit(OtkSuccess(listTambur: success));
        }
      },
    );
  }

  Future<void> _onUpdateTambur(
    UpdateTamburEvent event,
    Emitter<OtkState> emit,
  ) async {
    DialogUtils.showLoading();
    final result = await _otkUseCase.updateTambur(
      tamburId: event.tamburId,
      shift: event.shift,
      radius: event.radius,
      format: event.format,
    );

    result.fold(
      (failure) {
        DialogUtils.dismissLoading();
        DialogUtils.showErrorToast(failure.message);
      },
      (success) {
        DialogUtils.dismissLoading();
        event.onSuccess.call();
      },
    );
  }

  Future<void> _onCreateTambur(
    CreateTamburEvent event,
    Emitter<OtkState> emit,
  ) async {
    DialogUtils.showLoading();
    final result = await _otkUseCase.createTambur();

    result.fold(
      (failure) {
        DialogUtils.dismissLoading();
        DialogUtils.showErrorToast(failure.message);
      },
      (tambur) {
        DialogUtils.dismissLoading();
        event.onSuccess.call(tambur);
      },
    );
  }

  Future<void> _onUpdateWastePaper(
    UpdateWastePaperEvent event,
    Emitter<OtkState> emit,
  ) async {
    DialogUtils.showLoading();
    final result = await _otkUseCase.updateWastePaper(
      event.id,
      event.percent,
      event.weight,
      event.comment,
      event.carImage,
    );

    result.fold(
      (failure) {
        DialogUtils.dismissLoading();
        DialogUtils.showErrorToast(failure.message);
      },
      (success) {
        DialogUtils.dismissLoading();
        event.onSuccess.call();
      },
    );
  }
}
