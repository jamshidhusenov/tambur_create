import 'package:flutter/material.dart';

class ResponsivePlateInput extends StatefulWidget {
  final String carNumber;
  const ResponsivePlateInput({super.key, required this.carNumber});

  @override
  State<ResponsivePlateInput> createState() => _ResponsivePlateInputState();
}

class _ResponsivePlateInputState extends State<ResponsivePlateInput> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = width * 0.25; // avtomatik balandlik
        final fontSize = width * 0.08;
        final borderRadius = width * 0.05;

        return Center(
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                // Chap nuqta
                Container(
                  width: width * 0.02,
                  height: width * 0.02,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(width: 10),

                // Inputlar
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        widget.carNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 26,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Bayroq + UZ + nuqta
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icon/searchFlagBG.png',
                          fit: BoxFit.cover,
                          height: 40,
                        ),
                      ],
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: width * 0.02,
                      height: width * 0.02,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
