import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  testWidgets('daftar dan detail bersifat publik, detail bisa dicoba lagi', (
    tester,
  ) async {
    const entry = {
      'id': 'contoh',
      'nama_sekolah': 'Nama awal',
      'tingkat': 'sma',
      'tahun_masuk': 2020,
    };
    var details = 0;
    final api = ApiClient(
      client: MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.headers.containsKey('Authorization'), isFalse);
        if (request.url.path == '/api/v1/educations/') {
          return http.Response(jsonEncode([entry]), 200);
        }
        expect(request.url.path, '/api/v1/educations/contoh/');
        details++;
        if (details == 1) return http.Response('', 404);
        return http.Response(
          jsonEncode({
            ...entry,
            'nama_sekolah': 'Nama terbaru',
            'star_count': 2,
            'starred_by_names': 'adi, ria',
          }),
          200,
        );
      }),
    );
    addTearDown(api.close);
    await tester.pumpWidget(MyApp(apiClient: api));
    final list = find.text('Daftar Pendidikan');
    await tester.ensureVisible(list);
    await tester.tap(list);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nama awal'));
    await tester.pumpAndSettle();
    expect(find.text('Entri pendidikan tidak ditemukan.'), findsOneWidget);
    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();
    expect(find.text('Nama terbaru'), findsOneWidget);
    expect(find.text('contoh'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('adi, ria'),
      240,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Tidak dibintangi'), findsOneWidget);
    expect(details, 2);
  });
}
