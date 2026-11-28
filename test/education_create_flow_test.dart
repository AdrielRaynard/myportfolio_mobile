import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/education_navigation.dart';

void main() {
  testWidgets('Lihat daftar memuat hasil POST dan kembali ke beranda', (
    tester,
  ) async {
    await openForm(tester);
    await enterField(tester, 'Nama Sekolah / Universitas', 'SMA Cempaka');
    await enterField(tester, 'Tahun Masuk', '2022');
    await saveForm(tester);
    await tester.tap(find.text('Lihat daftar'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(Card, 'SMA Cempaka'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Tambah Pendidikan'), findsOneWidget);
  });
}
