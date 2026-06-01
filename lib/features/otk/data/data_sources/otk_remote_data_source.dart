import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tambur_create/core/constants/apis.dart';
import 'package:tambur_create/core/network/http_client.dart';
import 'package:tambur_create/core/services/logger_service.dart';
import 'package:tambur_create/core/services/token_service.dart';

class OtkRemoteDataSource {
  final ITokenService _tokenService;
  final IHttpClient _client;

  OtkRemoteDataSource({
    required ITokenService tokenService,
    required IHttpClient client,
  }) : _tokenService = tokenService,
       _client = client;

  Future<http.Response> createTambur() async {
    return _tokenService.makeAuthenticatedRequest((token) async {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await _client.post(
        '$baseUrl/api/v1/product/tambur/create/',
        headers: headers,
      );

      LoggerService.d(response.body);

      return response;
    });
  }


Future<http.Response> updateTambur({
  required int tamburId,
  required String shift,
  required int radius,
  required int format,
  int? brand,
}) async {
  return _tokenService.makeAuthenticatedRequest((token) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final Map<String, dynamic> bodyMap = {
      'shift': shift,
      'radius': radius,
      'format': format,
      'is_updated': true,
    };
    if (brand != null) {
      bodyMap['brand'] = brand;
    }

    final body = jsonEncode(bodyMap);

    final response = await _client.patch(
      '$baseUrl/api/v1/product/tambur/$tamburId/update/',
      headers: headers,
      body: body,
    );

    LoggerService.d('Update Tambur Response: ${response.body}');
    return response;
  });
}


  Future<http.Response> getListTambur() async {
    return _tokenService.makeAuthenticatedRequest((token) async {
      final headers = {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await _client.get(
        '$baseUrl/api/v1/product/tambur/list/',
        headers: headers,
      );

      LoggerService.d(response.body);
      return response;
    });
  }

  Future<http.Response> getBrands() async {
    return _tokenService.makeAuthenticatedRequest((token) async {
      final headers = {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await _client.get(
        '$baseUrl/api/v1/product/brand/small/list/',
        headers: headers,
      );

      LoggerService.d('Get Brands Response: ${response.body}');
      return response;
    });
  }

  Future<http.StreamedResponse> updateWastePaper({
    required int id,
    int? percent,
    int? weight,
    String? comment,
    XFile? carImage, // 🆕 Rasm fayl
  }) async {
    return _tokenService.makeAuthenticatedRequest((token) async {
      final uri = Uri.parse(
        '$baseUrl/api/v1/waste-paper/waste_paper/$id/update/in-otk/',
      );
      final request = http.MultipartRequest('PATCH', uri);

      // 🔐 Auth header
      request.headers['Authorization'] = 'Bearer $token';

      // 🔢 Form-data maydonlari
      if (percent != null) {
        request.fields['discount_percent'] = percent.toString();
      }
      if (weight != null) {
        request.fields['discount_weight'] = weight.toString();
      }
      if (comment != null) {
        request.fields['otk_comment'] = comment;
      }

      // 🖼️ Agar rasm mavjud bo‘lsa, qo‘shamiz
      if (carImage != null) {
        final multipartFile = await http.MultipartFile.fromPath(
          'car_image',
          carImage.path,
        );
        request.files.add(multipartFile);
      }

      LoggerService.d('PATCH: $uri');
      LoggerService.d('FIELDS: ${request.fields}');
      LoggerService.d('FILES: ${request.files.map((f) => f.filename)}');

      // 📤 So‘rovni yuborish
      final response = await request.send();

      // 🪵 Natijani log qilish uchun
      final responseBody = await response.stream.bytesToString();
      LoggerService.d('STATUS: ${response.statusCode}');
      LoggerService.d('BODY: $responseBody');

      return response;
    });
  }
}
