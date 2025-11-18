import 'package:flutter/material.dart';

class RollCard extends StatelessWidget {
  final String leftImagePath; // chap tomondagi rasm yo‘li
  final String tambur;
  final String rValue;
  final String time;
  final String formatValue;

  const RollCard({
    super.key,
    required this.leftImagePath,
    required this.tambur,
    required this.rValue,
    required this.time,
    required this.formatValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ===== LEFT IMAGE =====
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset(
              leftImagePath,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 16),

          // ===== RIGHT TEXT AREA =====
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Тамбур: $tambur",
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),
                    Text("Время: $time",
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),

                // Right column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("R: $rValue",
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),
                    Text("Формат $formatValue",
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
