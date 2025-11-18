import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tambur_create/core/theme/app_colors.dart';

class ToastUtil {
  static void showSuccess({
    required String message,
    required BuildContext context,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showToast(
      message: message,
      context: context,
      backgroundColor: AppColors.textGreen,
      duration: duration,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static void showError({
    required String message,
    required BuildContext context,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showToast(
      message: message,
      context: context,
      backgroundColor: AppColors.red,
      duration: duration,
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  static void showWarning({
    required String message,
    required BuildContext context,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showToast(
      message: message,
      context: context,
      backgroundColor: Colors.orange.shade800,
      duration: duration,
      icon: const Icon(Icons.warning, color: Colors.white),
    );
  }

  static void showInfo({
    required String message,
    required BuildContext context,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showToast(
      message: message,
      context: context,
      backgroundColor: Colors.blue.shade800,
      duration: duration,
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }

  static void showCustom({
    required String message,
    required BuildContext context,
    required Color backgroundColor,
    Widget? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showToast(
      message: message,
      context: context,
      backgroundColor: backgroundColor,
      duration: duration,
      icon: icon,
    );
  }

  static void _showToast({
    required String message,
    required BuildContext context,
    required Color backgroundColor,
    required Duration duration,
    Widget? icon,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    FToast fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      width: screenWidth - 32,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .2),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          if (icon != null) ...[icon, const SizedBox(width: 12)],
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: duration,
    );
  }
}

// Example usage:
// ToastUtil.showSuccess(message: "Operation completed successfully!", context: context);
// ToastUtil.showError(message: "An error occurred!", context: context);
// ToastUtil.showWarning(message: "Please be careful!", context: context);
// ToastUtil.showInfo(message: "Here's some information", context: context);
// ToastUtil.showCustom(
//   message: "Custom toast message",
//   backgroundColor: Colors.purple,
//   icon: Icon(Icons.star, color: Colors.white),
//   context: context,
// );
