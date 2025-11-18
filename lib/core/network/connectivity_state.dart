// // connectivity_state.dart
// import 'dart:async';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tambur_create/core/network/network_info.dart';

// abstract class ConnectivityState {
//   const ConnectivityState();
// }

// class ConnectivityInitial extends ConnectivityState {}

// class ConnectedState extends ConnectivityState {}

// class DisconnectedState extends ConnectivityState {}

// class ConnectivityCubit extends Cubit<ConnectivityState> {
//   final NetworkInfo networkInfo;
//   StreamSubscription? _connectivitySubscription;

//   ConnectivityCubit({required this.networkInfo})
//       : super(ConnectivityInitial()) {
//     _initConnectivity();
//   }

//   void _initConnectivity() async {
//     final isConnected = await networkInfo.isConnected;
//     emit(isConnected ? ConnectedState() : DisconnectedState());

//     _connectivitySubscription = networkInfo.onConnectivityChanged.listen(
//       (isConnected) {
//         if (isConnected) {
//           emit(ConnectedState());
//         } else {
//           emit(DisconnectedState());
//         }
//       },
//     );
//   }

//   @override
//   Future<void> close() {
//     _connectivitySubscription?.cancel();
//     return super.close();
//   }
// }
