import 'dart:convert';

import 'package:flutter/services.dart';

const _catalogAssetPath = 'assets/certificates/catalog.json';

class CertificateCatalog {
  const CertificateCatalog(this.certificates);

  final List<CertificateRecord> certificates;

  int get issuerCount =>
      certificates.map((certificate) => certificate.issuer).toSet().length;

  List<CertificateYearGroup> get groupsByYear {
    final certificatesByYear = <int, List<CertificateRecord>>{};
    for (final certificate in certificates) {
      certificatesByYear
          .putIfAbsent(certificate.completedOn.year, () => [])
          .add(certificate);
    }
    final groups = certificatesByYear.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    return List.unmodifiable([
      for (final group in groups)
        CertificateYearGroup(
          year: group.key,
          certificates: List.unmodifiable(group.value),
        ),
    ]);
  }

  static Future<CertificateCatalog> load() async {
    final source = await rootBundle.loadString(_catalogAssetPath);
    return CertificateCatalog.fromJsonString(source);
  }

  factory CertificateCatalog.fromJsonString(String source) {
    final root = jsonDecode(source);
    if (root is! Map<String, dynamic> || root['schema_version'] != 1) {
      throw const FormatException('Unsupported certificate catalog.');
    }
    final entries = root['certificates'];
    if (entries is! List) {
      throw const FormatException('Certificate catalog entries are missing.');
    }
    final certificates =
        entries
            .map((entry) => CertificateRecord.fromJson(entry))
            .toList(growable: false)
          ..sort((a, b) => b.completedOn.compareTo(a.completedOn));
    return CertificateCatalog(certificates);
  }
}

class CertificateRecord {
  const CertificateRecord({
    required this.id,
    required this.issuer,
    required this.title,
    required this.holder,
    required this.completedOn,
    required this.verificationUrl,
    required this.imageAssetPath,
    required this.pdfAssetPath,
    required this.technologies,
  });

  final String id;
  final String issuer;
  final String title;
  final String holder;
  final DateTime completedOn;
  final Uri verificationUrl;
  final String imageAssetPath;
  final String pdfAssetPath;
  final List<String> technologies;

  Uri get archivedPdfUrl => Uri.base.resolve('assets/$pdfAssetPath');

  factory CertificateRecord.fromJson(Object? source) {
    if (source is! Map<String, dynamic>) {
      throw const FormatException('Invalid certificate entry.');
    }
    final artifacts = source['artifacts'];
    if (artifacts is! Map<String, dynamic> ||
        artifacts['image'] is! Map<String, dynamic> ||
        artifacts['pdf'] is! Map<String, dynamic>) {
      throw const FormatException('Certificate artifacts are missing.');
    }
    final image = artifacts['image'] as Map<String, dynamic>;
    final pdf = artifacts['pdf'] as Map<String, dynamic>;
    return CertificateRecord(
      id: _requiredString(source, 'id'),
      issuer: _requiredString(source, 'issuer'),
      title: _requiredString(source, 'title'),
      holder: _requiredString(source, 'holder'),
      completedOn: DateTime.parse(_requiredString(source, 'completed_on')),
      verificationUrl: Uri.parse(_requiredString(source, 'verification_url')),
      imageAssetPath: _requiredString(image, 'path'),
      pdfAssetPath: _requiredString(pdf, 'path'),
      technologies: _requiredStringList(source, 'technologies'),
    );
  }
}

class CertificateYearGroup {
  const CertificateYearGroup({required this.year, required this.certificates});

  final int year;
  final List<CertificateRecord> certificates;
}

String _requiredString(Map<String, dynamic> source, String key) {
  final value = source[key];
  if (value is! String || value.isEmpty) {
    throw FormatException('Missing certificate field: $key');
  }
  return value;
}

List<String> _requiredStringList(Map<String, dynamic> source, String key) {
  final value = source[key];
  if (value is! List ||
      value.isEmpty ||
      value.any((tag) => tag is! String || tag.isEmpty)) {
    throw FormatException('Missing certificate field: $key');
  }
  return List.unmodifiable(value.cast<String>());
}
