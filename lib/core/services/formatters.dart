import 'package:flutter/services.dart';

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digits first
    String numbers = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Limit to 16 digits
    if (numbers.length > 16) {
      numbers = numbers.substring(0, 16);
    }

    String formatted = '';

    // Add spaces after every 4 digits
    for (int i = 0; i < numbers.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += numbers[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digits
    String numbers = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Limit to 4 digits
    if (numbers.length > 4) {
      numbers = numbers.substring(0, 4);
    }

    String formatted = '';

    // Add slash after first 2 digits
    for (int i = 0; i < numbers.length; i++) {
      if (i == 2) {
        formatted += '/';
      }
      formatted += numbers[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}