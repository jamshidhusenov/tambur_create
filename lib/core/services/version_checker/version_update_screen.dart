import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tambur_create/core/constants/apis.dart';
import 'package:tambur_create/core/theme/app_colors.dart';
import 'package:tambur_create/core/theme/app_text_styles.dart';

class VersionUpdateScreen extends StatelessWidget {
  final String currentVersion;
  final String serverVersion;
  final String message;

  const VersionUpdateScreen({
    super.key,
    required this.currentVersion,
    required this.serverVersion,
    required this.message,
  });

  Future<void> _launchTelegram() async {
    final Uri url = Uri.parse(adminNickName);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch \$url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.system_security_update,
                size: 64,
                color: Colors.blueAccent[400],
              ),
              const SizedBox(height: 24),
              Text(
                'Требуется обновление',
                style: AppTextStyles.s20cWfw500,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: AppTextStyles.s16cPfw600,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                'Для обновления обратитесь к администратору',
                style: AppTextStyles.s14cGfw400,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _launchTelegram,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/icons8-telegram.svg',
                      width: 48,
                      height: 48,
                    ),
                    Text(
                      'Написать администратору',
                      style: AppTextStyles.s16cPfw600,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
