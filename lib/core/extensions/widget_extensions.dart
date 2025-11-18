// core/extensions/widget_extensions.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension WidgetExtensions on Widget {
  Widget withPadding([EdgeInsets padding = const EdgeInsets.all(16)]) {
    return Padding(padding: padding, child: this);
  }

  Widget withLoading(bool isLoading, {Color? backgroundColor}) {
    return Stack(
      children: [
        this,
        if (isLoading)
          LoadingOverlay(backgroundColor: backgroundColor, opacity: 0.5),
      ],
    );
  }
}

extension DateTimeExtensions on DateTime {
  String get formattedDate =>
      '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.$year';

  String get formattedMinutes =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

extension IntExtensions on int {
  String get formattedAmount =>
      NumberFormat('#,###', 'en_US').format(this).replaceAll(',', ' ');
}

class LoadingOverlay extends StatelessWidget {
  final Color? backgroundColor;
  final Widget? loadingIndicator;
  final double opacity;

  const LoadingOverlay({
    super.key,
    this.backgroundColor,
    this.loadingIndicator,
    this.opacity = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: (backgroundColor ?? Colors.black).withValues(
                alpha: opacity,
              ),
            ),
          ),
          Center(child: loadingIndicator ?? _defaultLoadingIndicator(context)),
        ],
      ),
    );
  }

  Widget _defaultLoadingIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text('Loading...', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
