import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leone_signature/leone_signature.dart';

void main() {
  for (final (language, label) in [
    ('pt', 'Criado por'),
    ('en', 'Created by'),
    ('es', 'Creado por'),
  ]) {
    testWidgets(
      '$language signature remains usable with large text in a narrow footer',
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
                      locale: Locale(language),
                      onPressed: () => opened = true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        expect(find.text(label), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('Leone Daher'));
        expect(opened, isTrue);
      },
    );
  }
  test('portfolio destination follows the supported portfolio locales', () {
    expect(
      LeoneSignature.portfolioUri(const Locale('pt')),
      Uri.parse('https://leonedaher.com/pt/'),
    );
    expect(
      LeoneSignature.portfolioUri(const Locale('es')),
      Uri.parse('https://leonedaher.com/'),
    );
  });
}
