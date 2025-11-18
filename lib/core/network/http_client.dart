import 'dart:async';
import 'package:http/http.dart' as http;
import '../constants/time.dart';
import '../error/exceptions.dart';

abstract class IHttpClient {
  Future<http.Response> get(String url,
      {Map<String, String>? headers, Map<String, dynamic>? queryParameters});
  Future<http.Response> post(String url,
      {Map<String, String>? headers, Object? body, Map<String, dynamic>? queryParameters});
  Future<http.Response> put(String url,
      {Map<String, String>? headers, Object? body, Map<String, dynamic>? queryParameters});
  Future<http.Response> patch(String url,
      {Map<String, String>? headers, Object? body, Map<String, dynamic>? queryParameters});
  Future<http.Response> delete(String url,
      {Map<String, String>? headers, Map<String, dynamic>? queryParameters});
}

class HttpClient implements IHttpClient {
  final http.Client _client;

  HttpClient({http.Client? client}) : _client = client ?? http.Client();

  Uri _buildUri(String url, Map<String, dynamic>? queryParameters) {
    final uri = Uri.parse(url);
    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }
    return uri.replace(
      queryParameters: queryParameters.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  @override
  Future<http.Response> get(String url,
      {Map<String, String>? headers, Map<String, dynamic>? queryParameters}) async {
    try {
      final uri = _buildUri(url, queryParameters);
      final response = await _client
          .get(uri, headers: headers)
          .timeout(timeOut, onTimeout: () {
        throw TimeoutException();
      });
      return response;
    } catch (e) {
      if (e is TimeoutException) rethrow;
      throw ServerException(
        message: 'Server xatosi yuz berdi : ${e.toString()}',
        statusCode: 500,
        errorText: e.toString(),
      );
    }
  }

  @override
  Future<http.Response> post(String url,
      {Map<String, String>? headers,
      Object? body,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final uri = _buildUri(url, queryParameters);
      final response = await _client
          .post(uri, headers: headers, body: body)
          .timeout(timeOut, onTimeout: () {
        throw TimeoutException();
      });
      return response;
    } catch (e) {
      if (e is TimeoutException) rethrow;
      throw ServerException(
        message: 'Server xatosi yuz berdi : ${e.toString()}',
        statusCode: 500,
        errorText: e.toString(),
      );
    }
  }

  @override
  Future<http.Response> put(String url,
      {Map<String, String>? headers,
      Object? body,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final uri = _buildUri(url, queryParameters);
      final response = await _client
          .put(uri, headers: headers, body: body)
          .timeout(timeOut, onTimeout: () {
        throw TimeoutException();
      });
      return response;
    } catch (e) {
      if (e is TimeoutException) rethrow;
      throw ServerException(
        message: 'Server xatosi yuz berdi : ${e.toString()}',
        statusCode: 500,
        errorText: e.toString(),
      );
    }
  }

  @override
  Future<http.Response> patch(String url,
      {Map<String, String>? headers,
      Object? body,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final uri = _buildUri(url, queryParameters);
      final response = await _client
          .patch(uri, headers: headers, body: body)
          .timeout(timeOut, onTimeout: () {
        throw TimeoutException();
      });
      return response;
    } catch (e) {
      if (e is TimeoutException) rethrow;
      throw ServerException(
        message: 'Server xatosi yuz berdi : ${e.toString()}',
        statusCode: 500,
        errorText: e.toString(),
      );
    }
  }

  @override
  Future<http.Response> delete(String url,
      {Map<String, String>? headers, Map<String, dynamic>? queryParameters}) async {
    try {
      final uri = _buildUri(url, queryParameters);
      final response = await _client
          .delete(uri, headers: headers)
          .timeout(timeOut, onTimeout: () {
        throw TimeoutException();
      });
      return response;
    } catch (e) {
      if (e is TimeoutException) rethrow;
      throw ServerException(
        message: 'Server xatosi yuz berdi : ${e.toString()}',
        statusCode: 500,
        errorText: e.toString(),
      );
    }
  }
}
