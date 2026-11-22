import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/validation/education_validators.dart';

void main() {
  test('nama sekolah wajib berisi teks setelah markup dibersihkan', () {
    for (final input in [null, '', '   ', '<b> </b>', '<!-- catatan -->']) {
      expect(EducationValidators.schoolName(input), isNotNull, reason: input);
    }
    expect(EducationValidators.schoolName(' <b>SMA Melati</b> '), isNull);
    expect(EducationValidators.plainText(' <b>SMA Melati</b> '), 'SMA Melati');
  });

  test('nama sekolah dan jurusan menerima hingga 255 karakter Unicode', () {
    for (final validate in [
      EducationValidators.schoolName,
      EducationValidators.major,
    ]) {
      expect(validate('🎓' * 255), isNull);
      expect(validate('🎓' * 256), isNotNull);
    }
    expect(EducationValidators.major('   '), isNull);
  });

  test('kedua tahun wajib berupa bilangan bulat dalam rentang 1900–2100 jika diisi', () {
    for (final year in ['1900', '2100']) {
      expect(EducationValidators.startYear(year), isNull, reason: year);
      expect(
        EducationValidators.graduationYear(year, '1900'),
        isNull,
        reason: year,
      );
    }
    for (final year in ['1899', '2101', '2025.5', 'dua ribu']) {
      expect(EducationValidators.startYear(year), isNotNull, reason: year);
      expect(
        EducationValidators.graduationYear(year, '1900'),
        isNotNull,
        reason: year,
      );
    }
  });

  test(
    'tahun masuk wajib, tahun lulus boleh kosong, sama, atau lebih akhir',
    () {
      for (final blank in [null, '', '   ']) {
        expect(EducationValidators.startYear(blank), isNotNull);
        expect(EducationValidators.graduationYear(blank, '2025'), isNull);
      }
      expect(EducationValidators.graduationYear('2024', '2025'), isNotNull);
      expect(EducationValidators.graduationYear('2025', '2025'), isNull);
      expect(EducationValidators.graduationYear('2026', '2025'), isNull);
    },
  );
}
