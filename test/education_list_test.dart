import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';

import 'helpers/education_navigation.dart';

const university = 'Fakultas Ilmu Komputer, Universitas Indonesia';
const highSchool = 'SMAK PENABUR Bintaro Jaya';
const middleSchool = 'SMPK PENABUR Bintaro Jaya';

Future<void> selectOption(
  WidgetTester tester,
  String current,
  String next,
) async {
  await tester.tap(find.text(current).hitTestable());
  await tester.pumpAndSettle();
  await tester.tap(find.text(next).hitTestable());
  await tester.pumpAndSettle();
}

Future<void> openList(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  final card = find.text('Daftar Pendidikan');
  await tester.ensureVisible(card);
  await tester.tap(card);
  await tester.pumpAndSettle();
}

void expectAbove(WidgetTester tester, String first, String second) {
  expect(
    tester.getTopLeft(find.text(first)).dy,
    lessThan(tester.getTopLeft(find.text(second)).dy),
  );
}

void main() {
  testWidgets(
    'daftar awal diurutkan berdasarkan tahun masuk dan menampilkan data web',
    (tester) async {
      // Tampilkan ketiga kartu sekaligus agar posisi vertikal bisa dibandingkan.
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1400);
      addTearDown(tester.view.reset);
      await openList(tester);
      expect(find.text('Semua').hitTestable(), findsOneWidget);
      expect(find.text('Terbaru ke terlama').hitTestable(), findsOneWidget);
      expectAbove(tester, university, highSchool);
      expectAbove(tester, highSchool, middleSchool);
      expect(find.widgetWithText(Card, 'S1 · 2025–Sekarang'), findsOneWidget);
      expect(find.widgetWithText(Card, 'Sistem Informasi'), findsOneWidget);
      expect(
        find.widgetWithText(
          Card,
          'Menyelesaikan pendidikan jenjang menengah pertama.',
        ),
        findsOneWidget,
      );

      await selectOption(tester, 'Semua', 'S2');
      expect(find.text('Belum ada riwayat pendidikan S2.'), findsOneWidget);
      expect(find.byType(Card), findsNothing);
      await selectOption(tester, 'S2', 'S3');
      expect(find.text('Belum ada riwayat pendidikan S3.'), findsOneWidget);
      await selectOption(tester, 'S3', 'SMP');
      expect(find.widgetWithText(Card, middleSchool), findsOneWidget);
      await selectOption(tester, 'SMP', 'S1');
      expect(find.widgetWithText(Card, university), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    },
  );

  testWidgets(
    'entri formulir ikut difilter dan kedua urutan bekerja pada jenjang yang sama',
    (tester) async {
      const otherSchool = 'SMA Melati';
      await openForm(tester);
      await enterField(tester, 'Nama Sekolah / Universitas', otherSchool);
      await selectOption(tester, 'S1 (Sarjana)', 'SMA/SMK');
      await enterField(tester, 'Tahun Masuk', '2020');
      await saveForm(tester);
      await tester.tap(find.text('Tutup'));
      await tester.pumpAndSettle();
      await chooseFromDrawer(tester, 'Daftar Pendidikan');

      await selectOption(tester, 'Semua', 'SMA/SMK');
      expect(find.byType(Card), findsNWidgets(2));
      expectAbove(tester, highSchool, otherSchool);
      await selectOption(tester, 'Terbaru ke terlama', 'Terlama ke terbaru');
      expect(find.byType(Card), findsNWidgets(2));
      expectAbove(tester, otherSchool, highSchool);
      expect(find.text(university), findsNothing);
      await selectOption(tester, 'SMA/SMK', 'Semua');
      expectAbove(tester, middleSchool, otherSchool);
      expectAbove(tester, otherSchool, highSchool);

      await chooseFromDrawer(tester, 'Home');
      await chooseFromDrawer(tester, 'Daftar Pendidikan');
      await selectOption(tester, 'Semua', 'SMA/SMK');
      expect(find.widgetWithText(Card, otherSchool), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await openList(tester);
      await selectOption(tester, 'Semua', 'SMA/SMK');
      expect(find.widgetWithText(Card, otherSchool), findsNothing);
      expect(find.widgetWithText(Card, highSchool), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    },
  );
}
