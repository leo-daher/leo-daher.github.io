import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leone_signature/leone_signature.dart';

void main() {
  testWidgets(
    'localized signature remains usable with large text in a narrow footer',
    (tester) async {
      var opened = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2)),
              child: Center(
                child: SizedBox(
                  width: 280,
                  child: LeoneSignature(
                    locale: const Locale('pt'),
                    onPressed: () => opened = true,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Desenvolvido por'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Leone Daher'));
      expect(opened, isTrue);
    },
  );
  test('portfolio destination follows the supported portfolio locales', () {
    expect(LeoneSignature.portfolioUri(const Locale('pt')).path, '/pt/');
    expect(LeoneSignature.portfolioUri(const Locale('es')).path, '/');
  });
}
