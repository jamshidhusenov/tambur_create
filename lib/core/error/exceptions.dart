class ServerException implements Exception {
  final String message;
  final int statusCode;
  final String errorText;

  ServerException({
    required this.message,
    required this.statusCode,
    required this.errorText,
  });
}

class NetworkException implements Exception {
  final String message;
  NetworkException({this.message = 'Internet bilan aloqa yo\'q'});
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException({this.message = 'So\'rov vaqti tugadi'});
}

class CacheException implements Exception {
  final String message;
  CacheException({this.message = 'Kesh xatoligi'});
}
