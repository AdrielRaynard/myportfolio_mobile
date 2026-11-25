import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/education.dart';

void main() {
  test('membaca respons Django dan hanya mengirim enam field formulir', () {
    const fields = {
      'nama_sekolah': 'Universitas Indonesia',
      'tingkat': 'S1',
      'jurusan': 'Sistem Informasi',
      'tahun_masuk': 2025,
      'tahun_lulus': null,
      'deskripsi': 'Sedang menempuh studi.',
    };
    const id = '662b9077-42c8-42f1-8483-a1cec020b8b7';
    final education = Education.fromJson({
      ...fields,
      'id': id,
      'star_count': 2,
      'is_starred': true,
      'starred_by_names': 'adi, ria',
    });

    expect(education.id, id);
    expect(education.level, EducationLevel.s1);
    expect(education.starCount, 2);
    expect(education.isStarred, isTrue);
    expect(education.starredByNames, 'adi, ria');
    expect(education.toJson(), fields);
  });

  test('menerima field opsional kosong dan mempertahankan kode jenjang', () {
    for (final level in EducationLevel.values) {
      for (final optional in <Map<String, dynamic>>[
        {},
        {'deskripsi': null},
      ]) {
        final education = Education.fromJson({
          'nama_sekolah': 'Sekolah',
          'tingkat': level.code,
          'tahun_masuk': 2020,
          ...optional,
        });

        expect(education.major, isNull);
        expect(education.graduationYear, isNull);
        expect(education.description, '');
        expect(education.level, level);
        expect(education.toJson()['tingkat'], level.code);
      }
    }
  });
}
