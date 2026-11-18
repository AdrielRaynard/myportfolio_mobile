import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

void main() {
  testWidgets('menampilkan profil dan aksi portofolio dengan warna berbeda', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('2506587150'), findsOneWidget);
    expect(find.text('Adriel Raynard Davis Sihotang'), findsOneWidget);
    expect(find.text('PBP B'), findsOneWidget);
    expect(find.text('Lihat Proyek'), findsOneWidget);
    expect(find.text('Tambah Proyek'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
    expect(find.text('Tentang Portofolio'), findsOneWidget);

    expect(
      find.byWidgetPredicate(
        (Widget widget) => widget is Material && widget.color == Colors.indigo,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (Widget widget) => widget is Material && widget.color == Colors.teal,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Material && widget.color == Colors.deepOrange,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Material && widget.color == Colors.blueGrey,
      ),
      findsOneWidget,
    );
  });

  testWidgets('setiap aksi menampilkan SnackBar yang sesuai', (
    WidgetTester tester,
  ) async {
    const List<String> actions = <String>['Lihat Proyek', 'Logout'];

    for (final String action in actions) {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.text(action));

      // Tunggu animasi SnackBar sampai selesai.
      await tester.pumpAndSettle();

      expect(find.text('Kamu telah menekan tombol $action!'), findsOneWidget);

      // Bersihkan SnackBar sebelum menguji aksi berikutnya.
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('Tambah Proyek membuka halaman form proyek', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();

    expect(find.text('Add Project Form'), findsOneWidget);
    expect(find.byType(ProjectFormPage), findsOneWidget);
  });

  testWidgets('form proyek memvalidasi isian dan menampilkan data', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);

    final Finder fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'MyPortfolio');
    await tester.enterText(fields.at(1), 'Aplikasi portofolio Flutter');
    await tester.enterText(fields.at(2), 'Flutter, Material 3');
    await tester.enterText(fields.at(3), 'https://example.com');

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Nama Proyek: MyPortfolio'), findsOneWidget);
    expect(find.text('Deskripsi: Aplikasi portofolio Flutter'), findsOneWidget);
    expect(find.text('Kategori: Web Development'), findsOneWidget);
    expect(find.text('Teknologi: Flutter, Material 3'), findsOneWidget);
    expect(find.text('Tautan: https://example.com'), findsOneWidget);
  });

  testWidgets('Tentang Portofolio membuka ringkasan profil', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Tentang Portofolio'));
    await tester.pumpAndSettle();

    expect(find.text('Ringkasan Portofolio'), findsOneWidget);

    expect(
      find.text(
        'MyPortfolio Mobile adalah ruang awal untuk menyajikan profil '
        'dan mengembangkan koleksi proyek pribadi secara bertahap.',
      ),
      findsOneWidget,
    );

    expect(find.text('2506587150 - PBP B'), findsOneWidget);

    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    expect(find.text('Ringkasan Portofolio'), findsNothing);
  });
}
