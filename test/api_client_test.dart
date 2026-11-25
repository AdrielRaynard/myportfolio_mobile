import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  test(
    'mengambil token, membuat pendidikan, lalu logout dengan token',
    () async {
      const entry = Education(
        schoolName: 'École',
        level: EducationLevel.sma,
        startYear: 2020,
      );
      final client = ApiClient(
        client: MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.headers['Accept'], 'application/json');
          switch (request.url.path) {
            case '/api/v1/auth/token/':
              expect(jsonDecode(request.body), {
                'username': 'editor',
                'password': 'test',
              });
              return http.Response('{"token":"test-token"}', 200);
            case '/api/v1/educations/':
              expect(request.headers['Authorization'], 'Token test-token');
              expect(
                request.headers['Content-Type'],
                'application/json; charset=UTF-8',
              );
              expect(jsonDecode(request.body), entry.toJson());
              return http.Response.bytes(
                utf8.encode(jsonEncode({...entry.toJson(), 'id': 'server-id'})),
                201,
              );
            case '/api/v1/auth/logout/':
              expect(request.headers['Authorization'], 'Token test-token');
              return http.Response('', 204);
            default:
              throw StateError('Endpoint di luar pengujian: ${request.url}');
          }
        }),
      );
      addTearDown(client.close);
      final token = await client.obtainToken('editor', 'test');
      final saved = await client.createEducation(entry, token: token);
      expect(saved.schoolName, entry.schoolName);
      expect(saved.id, 'server-id');
      await client.logout(token: token);
    },
  );

  test('respons gagal melempar ApiException sebelum membaca JSON', () async {
    final client = ApiClient(
      client: MockClient((_) async => http.Response('Ditolak', 403)),
    );
    addTearDown(client.close);
    await expectLater(
      client.getEducations(),
      throwsA(
        isA<ApiException>()
            .having((error) => error.statusCode, 'statusCode', 403)
            .having((error) => error.message, 'message', 'Ditolak'),
      ),
    );
  });
}
