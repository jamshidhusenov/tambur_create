import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tambur_create/core/constants/apis.dart';
import 'package:tambur_create/core/constants/time.dart';
import 'package:tambur_create/core/error/exceptions.dart';

class UserRemoteDataSource {
  UserRemoteDataSource();

  Future<http.Response> loginUser(String phoneNumber, String password) async {
    try {
      var headers = {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      };

      var request = http.Request('POST', Uri.parse('$baseUrl/api/v1/token/'));

      request.body = json.encode({
        "phone_number": phoneNumber,
        "password": password,
      });
      request.headers.addAll(headers);

      var response = await request.send().timeout(
        timeOut,
        onTimeout: () {
          throw TimeoutException();
        },
      );

      final httpResponse = await http.Response.fromStream(response);

      return httpResponse;
    } catch (e) {
      if (e is TimeoutException) rethrow;
      throw ServerException(
        message: 'Server xatosi yuz berdi',
        statusCode: 500,
        errorText: e.toString(),
      );
    }
  }
}
