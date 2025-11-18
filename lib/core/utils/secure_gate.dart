import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class SecureGate extends StatelessWidget {
  final Widget child;

  const SecureGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Stack(
        children: [
          child,
          // This widget will prevent screenshots on iOS
          IgnorePointer(
            child: Visibility(
              visible: false,
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
        ],
      );
    }
    return child;
  }
}
