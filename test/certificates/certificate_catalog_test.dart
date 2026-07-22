import 'package:flutter_test/flutter_test.dart';
import 'package:leone_portfolio/features/certificates/certificate_catalog.dart';

void main() {
  group('CertificateCatalog', () {
    testWidgets('loads the verified certificate register from the asset', (
      tester,
    ) async {
      final catalog = await CertificateCatalog.load();

      expect(catalog.certificates, hasLength(12));
      expect(catalog.issuerCount, 2);
      expect(catalog.certificates.first.completedOn.year, 2026);
      expect(
        catalog.groupsByYear.map((group) => group.year),
        orderedEquals([2026, 2024, 2021]),
      );
      expect(catalog.groupsByYear[0].certificates, hasLength(10));
      expect(catalog.groupsByYear[1].certificates, hasLength(1));
      expect(catalog.groupsByYear[2].certificates, hasLength(1));
      expect(
        catalog.technologyTags,
        containsAll(const [
          '.NET 8',
          'AI',
          'ASP.NET Core',
          'Claude Code',
          'Flutter',
          'MCP',
        ]),
      );
      final aspNetCertificate = catalog.certificates.singleWhere(
        (certificate) =>
            certificate.id == 'udemy-uc-736004e1-63bd-4360-a1ed-9ee75a55bbad',
      );
      expect(
        aspNetCertificate.title,
        'Build ASP.NET Core Web API - Scratch To Finish (.NET8 API)',
      );
      expect(aspNetCertificate.holder, 'Leone Crespo Daher de Souza');
      expect(aspNetCertificate.completedOn, DateTime(2024, 4, 18));
      expect(
        aspNetCertificate.imageAssetPath,
        'assets/certificates/originals/'
        'udemy-build-asp-net-core-web-api-scratch-to-finish-net8-api.jpg',
      );
      expect(
        aspNetCertificate.technologies,
        orderedEquals(['ASP.NET Core', '.NET 8', 'C#', 'REST APIs']),
      );
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
