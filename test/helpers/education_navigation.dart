import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

Widget educationApp({
  List<Map<String, dynamic>> entries = const [],
  MockClientHandler? handleEducation,
}) {
  final rows = [...entries];
  final client = ApiClient(
    client: MockClient((request) async {
      switch (request.url.path) {
        case '/api/v1/auth/token/':
          return http.Response('{"token":"test-token"}', 200);
        case '/api/v1/auth/logout/':
          expect(request.headers['Authorization'], 'Token test-token');
          return http.Response('', 204);
        case '/api/v1/educations/':
          if (handleEducation != null) return handleEducation(request);
          if (request.method == 'GET') {
            expect(request.headers.containsKey('Authorization'), isFalse);
            return http.Response(jsonEncode(rows), 200);
          }
          expect(request.method, 'POST');
          expect(request.headers['Authorization'], 'Token test-token');
          final record = jsonDecode(request.body) as Map<String, dynamic>;
          rows.add(record);
          return http.Response(jsonEncode(record), 201);
        default:
          throw StateError('Unexpected endpoint: ${request.url.path}');
      }
    }),
  );
  addTearDown(client.close);
  return MyApp(apiClient: client);
}

Future<void> login(WidgetTester tester) async {
  await enterField(tester, 'Username', 'tester');
  await enterField(tester, 'Password', 'example');
  await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
  await tester.pumpAndSettle();
}

Future<void> openForm(WidgetTester tester, {Widget? app}) async {
  await tester.pumpWidget(app ?? educationApp());
  final card = find.text('Tambah Pendidikan');
  await tester.ensureVisible(card);
  await tester.tap(card);
  await tester.pumpAndSettle();
  await login(tester);
}

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
