import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tambur_create/core/theme/app_colors.dart';

class ImageZoomDialog extends StatelessWidget {
  final String? image;

  const ImageZoomDialog({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 10.0,
                  child: Image(
                    image: image != null
                        ? NetworkImage(image!)
                        : const AssetImage("assets/image/Error.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.white,
                  ),
                  child: const Icon(
                    CupertinoIcons.xmark,
                    color: AppColors.error,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
