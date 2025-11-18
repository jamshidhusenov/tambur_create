// import 'package:connectivity_plus/connectivity_plus.dart';

// abstract class NetworkInfo {
//   Stream<bool> get onConnectivityChanged;
//   Future<bool> get isConnected;
// }

// class NetworkInfoImpl implements NetworkInfo {
//   final _connectivity = Connectivity();

//   @override
//   Stream<bool> get onConnectivityChanged => _connectivity.onConnectivityChanged
//       .map((List<ConnectivityResult> events) => events.any((event) => event == ConnectivityResult.wifi || event == ConnectivityResult.mobile));

//   @override
//   Future<bool> get isConnected async {
//     final result = await _connectivity.checkConnectivity();
//     return result != ConnectivityResult.none;
//   }
// }
