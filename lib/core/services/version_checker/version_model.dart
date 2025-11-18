import 'package:flutter/material.dart'; // added import statement for Colors

class Version implements Comparable<Version> {
  final List<int> parts;

  Version(String version) : parts = version.split('.').map(int.parse).toList();

  @override
  int compareTo(Version other) {
    for (var i = 0; i < parts.length; i++) {
      if (i >= other.parts.length) return 1;
      if (parts[i] != other.parts[i]) {
        return parts[i].compareTo(other.parts[i]);
      }
    }
    return parts.length.compareTo(other.parts.length);
  }

  bool isGreaterThan(Version other) => compareTo(other) > 0;
  bool isLessThan(Version other) => compareTo(other) < 0;
  bool isEqual(Version other) => compareTo(other) == 0;

  @override
  String toString() => parts.join('.');
}

class AppVersion {
  final String version;
  final String buildNumber;
  final String minRequiredVersion;
  final bool forceUpdate;
  final String? updateMessage;
  final String? storeUrl;
  final Version versionObject;

  AppVersion({
    required this.version,
    required this.buildNumber,
    required this.minRequiredVersion,
    required this.forceUpdate,
    this.updateMessage,
    this.storeUrl,
  }) : versionObject = Version(version);

  factory AppVersion.fromJson(Map<String, dynamic> json) => AppVersion(
        version: json['version'] ?? '',
        buildNumber: json['buildNumber'] ?? '',
        minRequiredVersion: json['minRequiredVersion'] ?? '',
        forceUpdate: json['forceUpdate'] ?? false,
        updateMessage: json['updateMessage'],
        storeUrl: json['storeUrl'],
      );

  Map<String, dynamic> toJson() => {
        'version': version,
        'buildNumber': buildNumber,
        'minRequiredVersion': minRequiredVersion,
        'forceUpdate': forceUpdate,
        'updateMessage': updateMessage,
        'storeUrl': storeUrl,
      };
}

class ProjectVersionResponse {
  final int id;
  final String projectName;
  final String projectVersion;
  final DateTime updatedAt;
  final DateTime createdAt;
  final Version version;

  ProjectVersionResponse({
    required this.id,
    required this.projectName,
    required this.projectVersion,
    required this.updatedAt,
    required this.createdAt,
  }) : version = Version(projectVersion);

  factory ProjectVersionResponse.fromJson(Map<String, dynamic> json) => ProjectVersionResponse(
        id: json['id'] ?? 0,
        projectName: json['project_name'] ?? '',
        projectVersion: json['project_version'] ?? '0.0.0',
        updatedAt: DateTime.parse(json['updated_at']),
        createdAt: DateTime.parse(json['created_at']),
      );
}

enum VersionCheckResult {
  compatible,
  needsUpdate,
  error;

  String get message {
    switch (this) {
      case VersionCheckResult.compatible:
        return 'Ilova versiyasi mos';
      case VersionCheckResult.needsUpdate:
        return 'Iltimos ilovani yangilang';
      case VersionCheckResult.error:
        return 'Versiyani tekshirishda xatolik';
    }
  }

  Color get color {
    switch (this) {
      case VersionCheckResult.compatible:
        return Colors.green;
      case VersionCheckResult.needsUpdate:
        return Colors.red;
      case VersionCheckResult.error:
        return Colors.orange;
    }
  }
}
