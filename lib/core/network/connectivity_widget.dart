import 'package:flutter/material.dart';
import 'package:tambur_create/core/network/connectivity_service.dart';

class ConnectivityAwareWidget extends StatefulWidget {
  final Widget child;
  final ConnectivityService connectivityService;

  const ConnectivityAwareWidget({
    super.key,
    required this.child,
    required this.connectivityService,
  });

  @override
  State<ConnectivityAwareWidget> createState() =>
      _ConnectivityAwareWidgetState();
}

class _ConnectivityAwareWidgetState extends State<ConnectivityAwareWidget> {
  @override
  void initState() {
    super.initState();
    // Initialize service in the next frame when context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.connectivityService.initialize(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
