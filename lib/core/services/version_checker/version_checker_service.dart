import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'version_model.dart';
   
class VersionCheckerService {
  
  final String versionCheckUrl;
  final Duration timeout;
  final int maxRetries;
  
  VersionCheckerService({
    required this.versionCheckUrl,
    this.timeout = const Duration(seconds: 10),
    this.maxRetries = 3,
  });
  
  Future<PackageInfo> _getPackageInfo() async {
    try {
      return await PackageInfo.fromPlatform();
    } catch (e) {
      throw Exception('Ilova versiyasini olishda xatolik: $e');
    }
  }
  
  Future<ProjectVersionResponse> getServerVersion() async {
    int retryCount = 0;
    Exception? lastError;

    while (retryCount < maxRetries) {
      try {
        final response = await http
            .get(Uri.parse(versionCheckUrl))
            .timeout(timeout);
        
        if (response.statusCode == 200) {

          print('Server versiyasi: ${response.body}');
          final decodedResponse = utf8.decode(response.bodyBytes);
          return ProjectVersionResponse.fromJson(json.decode(decodedResponse));
        }
        
        throw Exception('Server xatosi: ${response.statusCode}');
      } on TimeoutException {
        lastError = Exception('So\'rov vaqti tugadi');
      } on http.ClientException catch (e) {
        lastError = Exception('Internet xatosi: $e');
      } catch (e) {
        lastError = Exception('Kutilmagan xatolik: $e');
      }

      retryCount++;
      if (retryCount < maxRetries) {
        await Future.delayed(Duration(seconds: retryCount * 2));
      }
    }

    throw lastError ?? Exception('Maksimal urinishlar soni tugadi');
  }

  Future<(VersionCheckResult, String)> _compareVersions(
    Version localVersion,
    Version serverVersion,
  ) async {
    try {
      if (localVersion.isEqual(serverVersion)) {
        return (VersionCheckResult.compatible, 'Versiyalar mos');
      } else if (localVersion.isLessThan(serverVersion)) {
        return (
          VersionCheckResult.needsUpdate,
          'Yangi versiya mavjud: ${serverVersion.toString()}'
        );
      } else {
        return (
          VersionCheckResult.compatible,
          'Lokal versiya yangiroq: ${localVersion.toString()}'
        );
      }
    } catch (e) {
      return (VersionCheckResult.error, 'Versiyalarni solishtrishda xatolik: $e');
    }
  }

  Future<(VersionCheckResult, String)> checkVersion() async {
    try {
      final packageInfo = await _getPackageInfo();
      final serverVersion = await getServerVersion();
      final localVersion = Version(packageInfo.version);
      
      return _compareVersions(localVersion, serverVersion.version);
    } catch (e) {
      return (VersionCheckResult.error, 'Version tekshirishda xatolik: $e');
    }
  }
}
