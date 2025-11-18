import 'package:logger/logger.dart';

class LoggerService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  static void d(String message) {
    _logger.d('💡 DEBUG: $message');
  }

  static void i(String message) {
    _logger.i('ℹ️ INFO: $message');
  }

  static void w(String message) {
    _logger.w('⚠️ WARNING: $message');
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e('❌ ERROR: $message', error: error, stackTrace: stackTrace);
  }
}

String getTovarString(int count) {
  if (count == 1) {
    return "товар";
  } else if (count >= 2 && count <= 4) {
    return "товара";
  } else {
    return "товаров";
  }
}
