import 'dart:convert';

ErrorResponse errorResponseFromJson(String str) =>
    ErrorResponse.fromJson(json.decode(str));

String errorResponseToJson(ErrorResponse data) => json.encode(data.toJson());

class ErrorResponse {
  String? detail;

  ErrorResponse({
    this.detail,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        detail: json["detail"],
      );

  Map<String, dynamic> toJson() => {
        "detail": detail,
      };
}

abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  final int statusCode;
  final String errorText;

  const ServerFailure({
    required String message,
    required this.statusCode,
    required this.errorText,
  }) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
