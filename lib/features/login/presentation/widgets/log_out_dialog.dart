import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tambur_create/core/theme/app_colors.dart';
import 'package:tambur_create/features/login/domain/services/logout_service.dart';

Future<void> logOutDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: AppColors.white,
        title: const Column(
          children: [
            Icon(Icons.logout_rounded, size: 50, color: AppColors.red),
            SizedBox(height: 16),
            Text(
              'Выход',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Вы действительно хотите выйти?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        actions: [
          SizedBox(
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Отмена', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final logoutService = LogoutService();
                await logoutService.logout();
                if (context.mounted) {
                  context.goNamed("initial");
                }
              },
              child: const Text('Выйти', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      );
    },
  );
}
