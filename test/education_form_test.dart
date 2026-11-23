import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';

void main() {
  testWidgets('opens education from the card and drawer', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Tambah Edukasi'));
    await tester.pumpAndSettle();
    expect(find.byType(EducationFormPage), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('MyPortfolio'), findsOneWidget);

    final drawer = find.byTooltip('Open navigation menu');
    await tester.tap(drawer);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Education'));
    await tester.pumpAndSettle();
    expect(find.byType(EducationFormPage), findsOneWidget);

    await tester.tap(drawer);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('MyPortfolio'), findsOneWidget);
  });

  testWidgets('shows education errors and opens the summary only when valid', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpWidget(const MaterialApp(home: EducationFormPage()));

    final institution = find.widgetWithText(
      TextFormField,
      'Nama Sekolah / Universitas',
    );
    final degree = find.widgetWithText(
      TextFormField,
      'Jenjang / Program Studi',
    );
    final description = find.widgetWithText(TextFormField, 'Deskripsi');
    final startYear = find.widgetWithText(TextFormField, 'Tahun Masuk');
    final endYear = find.widgetWithText(TextFormField, 'Tahun Selesai');
    final save = find.widgetWithText(FilledButton, 'Simpan');
    final dialog = find.byType(AlertDialog);

    Future<void> fill(Finder field, String value) async {
      await tester.ensureVisible(field);
      await tester.enterText(field, value);
      await tester.pumpAndSettle();
    }

    Future<void> tapVisible(Finder target) async {
      await tester.ensureVisible(target);
      await tester.pumpAndSettle();
      await tester.tap(target);
      await tester.pumpAndSettle();
    }

    void expectError(Finder field, String message) {
      expect(
        find.descendant(of: field, matching: find.text(message)),
        findsOneWidget,
      );
    }

    tester.view.viewInsets = const FakeViewPadding(bottom: 250);
    await tester.pumpAndSettle();

    await fill(institution, '   ');
    await fill(degree, List.filled(256, 'a').join());
    await fill(description, 'Program sarjana');
    await fill(startYear, '2025');
    await fill(endYear, '2024');
    await tapVisible(save);

    expectError(institution, 'Kolom ini wajib diisi.');
    expectError(degree, 'Maksimal 255 karakter.');
    expectError(endYear, 'Tahun selesai tidak boleh sebelum tahun masuk.');
    expect(dialog, findsNothing);

    tester.view.resetViewInsets();
    await tester.pumpAndSettle();

    await fill(institution, 'Universitas Indonesia');
    await fill(degree, 'Sistem Informasi');
    await fill(endYear, '2029');
    await tapVisible(save);

    expect(dialog, findsOneWidget);
    for (final line in [
      'Institusi: Universitas Indonesia',
      'Jenjang / Program Studi: Sistem Informasi',
      'Deskripsi: Program sarjana',
      'Tahun Masuk: 2025',
      'Tahun Selesai: 2029',
      'Masih menempuh pendidikan: Tidak',
    ]) {
      expect(
        find.descendant(of: dialog, matching: find.text(line)),
        findsOneWidget,
      );
    }

    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();
    expect(dialog, findsNothing);
    expect(find.text('Universitas Indonesia'), findsOneWidget);

    await tapVisible(find.byType(SwitchListTile));
    expect(endYear, findsNothing);
    await tapVisible(save);

    expect(dialog, findsOneWidget);
    expect(find.text('Tahun Selesai: Belum selesai'), findsOneWidget);
    expect(find.text('Masih menempuh pendidikan: Ya'), findsOneWidget);
  });
}
