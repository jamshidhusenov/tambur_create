import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// A service that monitors internet connectivity.
/// 
/// This service monitors network connectivity changes and shows UI alerts.
class ConnectivityService {
  // Constants for timing configurations
  static const Duration _debounceTime = Duration(milliseconds: 500);
  static const Duration _checkTimeout = Duration(seconds: 5);
  static const Duration _dialogDismissCheckDelay = Duration(milliseconds: 300);

  final Connectivity _connectivity = Connectivity();
  final InternetConnectionChecker _internetChecker = InternetConnectionChecker.instance;
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  late StreamSubscription<InternetConnectionStatus> _internetSubscription;
  bool _hasInternet = true;
  bool _isShowingDialog = false;
  bool _isChecking = false;
  Timer? _debounceTimer;
  
  // Stream controller to broadcast connectivity status
  final _connectivityController = StreamController<bool>.broadcast();
  
  /// Stream that broadcasts connectivity status changes (true = connected, false = disconnected)
  Stream<bool> get connectivityStream => _connectivityController.stream;
  
  /// Current connectivity status (true = connected, false = disconnected)
  bool get hasInternet => _hasInternet;
  
  ConnectivityService() {
    // Configure internet checker timeout
    InternetConnectionChecker.createInstance(
      checkTimeout: _checkTimeout,
    );
  }

  /// Initialize the connectivity service
  /// 
  /// This starts monitoring connectivity changes and shows UI alerts
  void initialize(dynamic _) {
    _checkInitialConnectivity();
    
    // Listen to connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      print('Connectivity changed: $results');
      _debounceConnectivityChange(() async {
        if (results.every((result) => result == ConnectivityResult.none)) {
          _updateConnectivityStatus(false);
        } else {
          // If we have network connectivity, verify internet connection
          final hasInternet = await _internetChecker.hasConnection;
          print('Internet check result: $hasInternet');
          _updateConnectivityStatus(hasInternet);
        }
      });
    });

    // Also listen to internet checker status
    _internetSubscription = _internetChecker.onStatusChange.listen((status) {
      print('Internet status changed: $status');
      _debounceConnectivityChange(() {
        _updateConnectivityStatus(status == InternetConnectionStatus.connected);
      });
    });
  }

  void _debounceConnectivityChange(VoidCallback callback) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceTime, callback);
  }

  /// Check the initial connectivity status
  Future<void> _checkInitialConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.every((result) => result == ConnectivityResult.none)) {
        _updateConnectivityStatus(false);
      } else {
        final hasInternet = await _internetChecker.hasConnection;
        _updateConnectivityStatus(hasInternet);
      }
    } catch (e) {
      print('Error checking initial connectivity: $e');
      _updateConnectivityStatus(false);
    }
  }

  /// Manually check internet connectivity
  Future<void> checkConnectivity() async {
    if (_isChecking) return;
    
    _isChecking = true;
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.every((result) => result == ConnectivityResult.none)) {
        _updateConnectivityStatus(false);
      } else {
        final hasInternet = await _internetChecker.hasConnection;
        _updateConnectivityStatus(hasInternet);
      }
    } catch (e) {
      print('Error checking connectivity: $e');
    } finally {
      _isChecking = false;
    }
  }

  /// Update the connectivity status and show/hide the dialog
  void _updateConnectivityStatus(bool hasInternet) {
    print('Updating connectivity status: hasInternet=$hasInternet, _hasInternet=$_hasInternet, _isShowingDialog=$_isShowingDialog');
    
    if (_hasInternet == hasInternet) {
      print('Skipping update - status unchanged');
      return;
    }

    _hasInternet = hasInternet;
    _connectivityController.add(_hasInternet);
    
    // Show or dismiss the dialog based on connectivity
    if (!hasInternet && !_isShowingDialog) {
      _showNoInternetDialog();
    } else if (hasInternet && _isShowingDialog) {
      print('Dismissing dialog');
      _dismissDialog();
    }
  }

  void _dismissDialog() {
    if (!_isShowingDialog) return;
    
    print('Force dismissing dialog');
    _isShowingDialog = false;
    SmartDialog.dismiss(force: true);
    
    // Double-check after a delay to ensure dialog is dismissed
    Future.delayed(_dialogDismissCheckDelay, () {
      if (SmartDialog.config.isExist) {
        print('Dialog still exists, forcing dismiss again');
        SmartDialog.dismiss(force: true);
      }
    });
  }

  /// Show a smart dialog when there's no internet connection
  void _showNoInternetDialog() {
    if (_isShowingDialog) {
      print('Dialog already showing, dismissing first');
      _dismissDialog();
    }
    
    print('Showing no internet dialog');
    _isShowingDialog = true;
    
    SmartDialog.show(
      permanent: true,
      maskColor: Colors.black.withOpacity(0.3),
      alignment: Alignment.center,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemRed.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.wifi_slash,
                      color: CupertinoColors.systemRed.resolveFrom(context),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Internet aloqasi mavjud emas',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.label.resolveFrom(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Iltimos, internet aloqangizni tekshiring',
                    style: TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      ),
                      onPressed: _isChecking ? null : checkConnectivity,
                      child: _isChecking
                          ? const CupertinoActivityIndicator()
                          : Text(
                              'Tekshirish',
                              style: TextStyle(
                                fontSize: 17,
                                color: CupertinoColors.activeBlue.resolveFrom(context),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Dispose resources when the service is no longer needed
  void dispose() {
    _subscription.cancel();
    _internetSubscription.cancel();
    _connectivityController.close();
    _debounceTimer?.cancel();
    _dismissDialog();
  }
}
