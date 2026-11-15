import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myportofolio_mobile/main.dart';

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
    const List<String> actions = <String>[
      'Lihat Proyek',
      'Tambah Proyek',
      'Logout',
    ];

    for (final String action in actions) {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text(action));
      await tester.pump();

      expect(find.text('Kamu telah menekan tombol $action!'), findsOneWidget);

      await tester.pumpAndSettle();
    }
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
