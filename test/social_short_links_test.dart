import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('social short links redirect to tracked home URLs', () {
    const redirects = {'ig': 'ig', 'in': 'in'};

    for (final entry in redirects.entries) {
      final html = File('web/${entry.key}/index.html').readAsStringSync();

      expect(html, contains("window.location.replace('/?ref=${entry.value}')"));
      expect(html, contains('content="0;url=/?ref=${entry.value}"'));
    }
  });
}
