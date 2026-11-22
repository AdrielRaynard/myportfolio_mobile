import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';

const school = 'Nama Sekolah / Universitas';
const startYear = 'Tahun Masuk';
const graduationYear = 'Tahun Lulus (opsional)';

Future<void> enterField(WidgetTester tester, String label, String value) async {
  final field = find.widgetWithText(TextFormField, label);
  await tester.ensureVisible(field);
  await tester.enterText(field, value);
  await tester.pumpAndSettle();
}

Future<void> saveForm(WidgetTester tester) async {
  final save = find.widgetWithText(FilledButton, 'Simpan');
  await tester.ensureVisible(save);
  await tester.pumpAndSettle();
  expect(save.hitTestable(), findsOneWidget);
  await tester.tap(save);
  await tester.pumpAndSettle();
}

Future<void> chooseFromDrawer(WidgetTester tester, String label) async {
  await tester.tap(find.byType(DrawerButton));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(ListTile, label));
  await tester.pumpAndSettle();
}

void expectHome(WidgetTester tester) {
  final home = find.byType(MyHomePage);
  expect(home, findsOneWidget);
  expect(Navigator.of(tester.element(home)).canPop(), isFalse);
}

void expectSummaryValue(String label, String value) {
  expect(
    find.descendant(
      of: find.byType(AlertDialog),
      matching: find.text('$label\n$value'),
    ),
    findsOneWidget,
  );
}

void main() {
  testWidgets(
    'kartu membuka formulir dan tombol kembali perangkat menuju beranda',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      final card = find.text('Tambah Pendidikan');
      await tester.ensureVisible(card);
      await tester.tap(card);
      await tester.pumpAndSettle();
      expect(find.byType(EducationFormPage), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expectHome(tester);
    },
  );

  testWidgets('drawer membuka formulir dan Home kembali ke beranda semula', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await chooseFromDrawer(tester, 'Tambah Pendidikan');
    expect(find.byType(EducationFormPage), findsOneWidget);

    await chooseFromDrawer(tester, 'Home');
    expectHome(tester);
  });

  testWidgets(
    'Simpan menandai kedua isian wajib yang kosong atau hanya spasi',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: EducationFormPage()));
      for (final input in ['', '   ']) {
        await enterField(tester, school, input);
        await enterField(tester, startYear, input);
        await saveForm(tester);
        expect(
          find.widgetWithText(
            TextFormField,
            'Masukkan nama sekolah atau universitas.',
          ),
          findsOneWidget,
        );
        expect(
          find.widgetWithText(TextFormField, 'Masukkan tahun masuk.'),
          findsOneWidget,
        );
        expect(find.byType(AlertDialog), findsNothing);
      }
    },
  );

  testWidgets(
    'kesalahan urutan tahun muncul di kolom Tahun Lulus dan bisa diperbaiki',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: EducationFormPage()));
      await enterField(tester, school, 'SMA Melati');
      await enterField(tester, startYear, '2025');
      await enterField(tester, graduationYear, '2024');
      await saveForm(tester);
      expect(
        find.descendant(
          of: find.widgetWithText(TextFormField, graduationYear),
          matching: find.text(
            'Tahun lulus tidak boleh lebih awal dari tahun masuk.',
          ),
        ),
        findsOneWidget,
      );
      expect(find.byType(AlertDialog), findsNothing);

      await enterField(tester, graduationYear, '2025');
      await saveForm(tester);
      expectSummaryValue('Tahun Lulus', '2025');
    },
  );

  testWidgets(
    'ringkasan menampilkan keenam nilai dan Tutup mengembalikan pengguna ke formulir',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: EducationFormPage()));
      await enterField(tester, school, 'Universitas Melati');
      await tester.tap(find.text('S1 (Sarjana)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('S2 (Magister)').hitTestable());
      await tester.pumpAndSettle();
      await enterField(tester, 'Jurusan (opsional)', 'Informatika');
      await enterField(tester, startYear, '2020');
      await enterField(tester, graduationYear, '2022');
      await enterField(
        tester,
        'Deskripsi Pendidikan (opsional)',
        'Riset komputasi',
      );
      await saveForm(tester);

      expect(find.text('Ringkasan Pendidikan'), findsOneWidget);
      expectSummaryValue(school, 'Universitas Melati');
      expectSummaryValue('Tingkat Pendidikan', 'S2 (Magister)');
      expectSummaryValue('Jurusan', 'Informatika');
      expectSummaryValue(startYear, '2020');
      expectSummaryValue('Tahun Lulus', '2022');
      expectSummaryValue('Deskripsi Pendidikan', 'Riset komputasi');
      await tester.tap(find.text('Tutup'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(
        find.widgetWithText(TextFormField, 'Universitas Melati'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Simpan dapat digulir dan ditekan di layar sempit dengan papan ketik terbuka',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 568);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const MaterialApp(home: EducationFormPage()));
      await enterField(tester, school, 'SMA Melati');
      await enterField(tester, startYear, '2025');
      tester.view.viewInsets = const FakeViewPadding(bottom: 240);
      await tester.pumpAndSettle();

      final save = find.widgetWithText(FilledButton, 'Simpan');
      await tester.dragUntilVisible(
        save.hitTestable(),
        find.byType(SingleChildScrollView),
        const Offset(0, -160),
      );
      await tester.pumpAndSettle();
      expect(tester.testTextInput.isVisible, isTrue);
      final keyboardTop =
          tester.view.physicalSize.height - tester.view.viewInsets.bottom;
      expect(tester.getBottomLeft(save).dy, lessThanOrEqualTo(keyboardTop));
      expect(save.hitTestable(), findsOneWidget);
      await tester.tap(save);
      tester.view.resetViewInsets();
      await tester.pumpAndSettle();

      expectSummaryValue('Tingkat Pendidikan', 'S1 (Sarjana)');
      expectSummaryValue('Tahun Lulus', 'Sekarang');
      expectSummaryValue('Jurusan', 'Tidak diisi');
      expectSummaryValue('Deskripsi Pendidikan', 'Tidak diisi');
    },
  );
}
