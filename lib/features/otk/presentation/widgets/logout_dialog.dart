import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:tambur_create/features/otk/domain/services/logout_service.dart';

class LogoutDialog {
  /// Shows an iOS-style logout confirmation dialog
  static Future<void> show(BuildContext context) async {
    return showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Chiqish'),
          content: const Text('Haqiqatan ham chiqmoqchimisiz?'),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('Bekor qilish'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.pop(context);
                final logoutService = LogoutService();
                final result = await logoutService.logout();
                if (result && context.mounted) {
                  context.goNamed('login');
                }
              },
              child: const Text('Chiqish'),
            ),
          ],
        );
      },
    );
  }
}
