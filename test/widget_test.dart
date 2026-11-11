import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('shows the portfolio identity and each menu message', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Callysta Arviana'), findsOneWidget);
    expect(find.text('2506619045'), findsOneWidget);
    expect(find.text('PBP A'), findsOneWidget);

    for (final name in ['Lihat Proyek', 'Tambah Proyek', 'Logout']) {
      await tester.tap(find.text(name));
      await tester.pumpAndSettle();

      expect(find.text('Kamu telah menekan tombol $name!'), findsOneWidget);
    }
  });
}
