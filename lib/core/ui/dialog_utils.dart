import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:tambur_create/core/services/logger_service.dart';

/// Configuration class for toast messages
class ToastConfig {
  final Color backgroundColor;
  final Duration displayTime;
  final Duration animationTime;

  const ToastConfig({
    this.backgroundColor = Colors.black54,
    this.displayTime = const Duration(seconds: 2),
    this.animationTime = const Duration(milliseconds: 300),
  });
}

/// Utility class for showing dialogs and toast messages
class DialogUtils {
  // Dialog configuration constants
  static const successToastConfig = ToastConfig(
    backgroundColor: Colors.green,
    displayTime: Duration(seconds: 3),
  );

  static const errorToastConfig = ToastConfig(
    backgroundColor: Colors.red,
    displayTime: Duration(seconds: 4),
  );

  /// Shows a loading dialog with custom configuration
  static void showLoading({String message = 'Iltimos kuting...'}) {
    LoggerService.d('Showing loading dialog: $message');
    SmartDialog.showLoading(
      msg: message,
      backDismiss: false,
      animationBuilder: (controller, child, animationParam) {
        return FadeTransition(
          opacity: controller.drive(CurveTween(curve: Curves.easeInOut)),
          child: ScaleTransition(
            scale: controller.drive(CurveTween(curve: Curves.easeInOut)),
            child: child,
          ),
        );
      },
    );
  }

  /// Dismisses any active dialog
  static void dismissLoading() {
    LoggerService.d('Dismissing loading dialog');
    SmartDialog.dismiss();
  }

  /// Shows a success toast message with custom styling
  static void showSuccessToast(String message) {
    LoggerService.d('Showing success toast: $message');
    SmartDialog.showToast(
      message,
      displayTime: successToastConfig.displayTime,
      alignment: Alignment.center,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: successToastConfig.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Shows an error toast message with custom styling
  static void showErrorToast(String message) {
    LoggerService.d('Showing error toast: $message');
    SmartDialog.showToast(
      message,
      displayTime: errorToastConfig.displayTime,
      alignment: Alignment.center,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: errorToastConfig.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    message,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
