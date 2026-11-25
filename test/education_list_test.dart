import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/education_navigation.dart';

// Data awal dari main/migrations/0003_populate_education.py di repo web.
const initialEducation = [
  Education(
    schoolName: 'SMPK PENABUR Bintaro Jaya',
    level: EducationLevel.smp,
    startYear: 2019,
    graduationYear: 2022,
    description: 'Menyelesaikan pendidikan jenjang menengah pertama.',
  ),
  Education(
    schoolName: 'SMAK PENABUR Bintaro Jaya',
    level: EducationLevel.sma,
    major: 'Matematika dan Ilmu Pengetahuan Alam (MIPA)',
    startYear: 2022,
    graduationYear: 2025,
    description:
        'Menyelesaikan pendidikan jenjang menengah atas dengan fokus '
        'pada matematika dan ilmu pengetahuan alam.',
  ),
  Education(
    schoolName: 'Fakultas Ilmu Komputer, Universitas Indonesia',
    level: EducationLevel.s1,
    major: 'Sistem Informasi',
    startYear: 2025,
    description:
        'Sedang menempuh studi S1 Sistem Informasi di Fakultas Ilmu '
        'Komputer Universitas Indonesia.',
  ),
];

Widget testApp({MockClientHandler? handler}) {
  return educationApp(
    entries: initialEducation.map((entry) => entry.toJson()).toList(),
    handleEducation: handler,
  );
}

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

Future<void> openList(WidgetTester tester, {MockClientHandler? handler}) async {
  await tester.pumpWidget(testApp(handler: handler));
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
  testWidgets('coba lagi, tarik daftar kosong, lalu buka detail', (
    tester,
  ) async {
    var calls = 0;
    await openList(
      tester,
      handler: (request) async {
        expect(request.url.path, '/api/v1/educations/');
        calls++;
        return switch (calls) {
          1 => http.Response('<html>debug</html>', 503),
          2 => http.Response('[]', 200),
          _ => http.Response(
            jsonEncode([initialEducation.first.toJson()]),
            200,
          ),
        };
      },
    );
    expect(find.textContaining('debug'), findsNothing);
    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada riwayat pendidikan.'), findsOneWidget);
    await tester.fling(
      find.byType(CustomScrollView),
      const Offset(0, 400),
      1000,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(middleSchool));
    await tester.pumpAndSettle();
    expect(find.text('Detail Pendidikan'), findsOneWidget);
    expect(find.text(middleSchool), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(calls, 3);
  });

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
      await openForm(tester, app: testApp());
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
