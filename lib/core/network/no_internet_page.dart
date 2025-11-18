// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tambur_create/core/network/connectivity_state.dart';

// class NoInternetPage extends StatelessWidget {
//   const NoInternetPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.wifi_off, size: 64),
//             const SizedBox(height: 16),
//             const Text('Internet aloqasi mavjud emas'),
//             BlocListener<ConnectivityCubit, ConnectivityState>(
//               listener: (context, state) {
//                 if (state is ConnectedState) {
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: const SizedBox(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
