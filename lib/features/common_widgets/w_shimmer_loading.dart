import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WShimmerLoading extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry? padding;
  final Color? baseColor;
  final Color? highlightColor;
  final Color? containerColor;
  final BorderRadius? borderRadius;
  final double? itemSpacing;
 
  const WShimmerLoading({
    super.key,
    this.itemCount = 6,
    this.itemHeight = 160,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    this.baseColor,
    this.highlightColor,
    this.containerColor,
    this.borderRadius,
    this.itemSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey[300]!,
      highlightColor: highlightColor ?? Colors.grey[100]!,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: itemSpacing ?? 16),
              child: Container(
                height: itemHeight,
                decoration: BoxDecoration(
                  color: containerColor ?? const Color(0xffd9d9d9) .withValues(alpha: 0.27),
                  borderRadius: borderRadius,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
