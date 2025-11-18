import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tambur_create/core/network/http_client.dart';
import 'package:tambur_create/features/login/domain/services/logout_service.dart';
import '../constants/apis.dart';
import '../error/exceptions.dart';

abstract class ITokenService {
  Future<String> getAccessToken();
  Future<void> refreshTokens();
  Future<T> makeAuthenticatedRequest<T>(
    Future<T> Function(String token) request,
  );
  Future<void> saveTokens(String accessToken, String refreshToken);
  Future<void> clearTokens();
}

class TokenService implements ITokenService {
  final FlutterSecureStorage _storage;
  final IHttpClient _client;
  static const String _accessTokenKey = "accessToken";
  static const String _refreshTokenKey = "refreshToken";

  TokenService({FlutterSecureStorage? storage, IHttpClient? client})
    : _storage = storage ?? const FlutterSecureStorage(),
      _client = client ?? HttpClient();

  @override
  Future<String> getAccessToken() async {
    try {
      final token = await _storage.read(key: _accessTokenKey);
      if (token == null || token.isEmpty) {
        throw ServerException(
          message: 'Access token not found',
          statusCode: 401,
          errorText: 'No access token in storage',
        );
      }
      return token;
    } catch (e) {
      throw ServerException(
        message: 'Failed to get access token',
        statusCode: 401,
        errorText: e.toString(),
      );
    }
  }

  Future<String> _getRefreshToken() async {
    try {
      final token = await _storage.read(key: _refreshTokenKey);
      if (token == null || token.isEmpty) {
        throw ServerException(
          message: 'Refresh token not found',
          statusCode: 401,
          errorText: 'No refresh token in storage',
        );
      }
      return token;
    } catch (e) {
      throw ServerException(
        message: 'Failed to get refresh token',
        statusCode: 401,
        errorText: e.toString(),
      );
    }
  }

  @override
  Future<void> refreshTokens() async {
    try {
      final refreshToken = await _getRefreshToken();
      final headers = {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      };

      final response = await _client.post(
        '$baseUrl/api/v1/token/refresh/',
        headers: headers,
        body: json.encode({"refresh": refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await saveTokens(data['access'], refreshToken);
      } else if (response.statusCode == 401) {
        final logoutService = LogoutService();
        await logoutService.logout();

        // if (context.mounted) {
        //   context.goNamed("home");
        // }
      } else {
        throw ServerException(
          message: 'Token refresh failed',
          statusCode: response.statusCode,
          errorText: response.body,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'Token refresh failed',
        statusCode: 500,
        errorText: e.toString(),
      );
    }
  }

  @override
  Future<T> makeAuthenticatedRequest<T>(
    Future<T> Function(String token) request,
  ) async {
    try {
      String token = await getAccessToken();
      T response = await request(token);

      if (response is http.Response && response.statusCode == 401) {
        await refreshTokens();
        token = await getAccessToken();
        response = await request(token);
      }

      return response;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'Request failed',
        statusCode: 500,
        errorText: e.toString(),
      );
    }
  }

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    try {
      await Future.wait([
        _storage.write(key: _accessTokenKey, value: accessToken),
        _storage.write(key: _refreshTokenKey, value: refreshToken),
      ]);
    } catch (e) {
      throw ServerException(
        message: 'Failed to save tokens',
        statusCode: 500,
        errorText: e.toString(),
      );
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await Future.wait([
        _storage.delete(key: _accessTokenKey),
        _storage.delete(key: _refreshTokenKey),
      ]);
    } catch (e) {
      throw ServerException(
        message: 'Failed to clear tokens',
        statusCode: 500,
        errorText: e.toString(),
      );
    }
  }
}
