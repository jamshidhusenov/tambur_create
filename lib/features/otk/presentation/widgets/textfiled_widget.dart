import 'package:flutter/material.dart';

class CustomRightWidgetTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Widget rightWidget;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextStyle? textStyle;

  const CustomRightWidgetTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.rightWidget,
    this.readOnly = false,
    this.onTap,
    this.textStyle = const TextStyle(fontSize: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),

        // Main container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: readOnly,
                  onTap: onTap,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: textStyle,
                ),
              ),

              const SizedBox(width: 8),

              // Right side widget
              rightWidget,
            ],
          ),
        ),
      ],
    );
  }
}
