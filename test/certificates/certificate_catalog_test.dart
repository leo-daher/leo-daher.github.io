import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/features/certificates/certificate_catalog.dart';

void main() {
  group('CertificateCatalog', () {
    testWidgets('loads the verified certificate register from the asset', (
      tester,
    ) async {
      final catalog = await CertificateCatalog.load();

      expect(catalog.certificates, hasLength(11));
      expect(catalog.issuerCount, 2);
      expect(catalog.certificates.first.completedOn.year, 2026);
      expect(
        catalog.groupsByYear.map((group) => group.year),
        orderedEquals([2026, 2021]),
      );
      expect(catalog.groupsByYear[0].certificates, hasLength(10));
      expect(catalog.groupsByYear[1].certificates, hasLength(1));
      expect(
        catalog.certificates.map((certificate) => certificate.technologies),
        everyElement(isNotEmpty),
      );
      expect(
        catalog.certificates.map(
          (certificate) => certificate.verificationUrl.scheme,
        ),
        everyElement('https'),
      );
    });

    test('rejects a catalog with an unsupported schema', () {
      expect(
        () => CertificateCatalog.fromJsonString(
          '{"schema_version": 2, "certificates": []}',
        ),
        throwsFormatException,
      );
    });
  });
}
