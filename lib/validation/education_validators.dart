abstract final class EducationValidators {
  static const int maxNameLength = 255;
  static const int minYear = 1900;
  static const int maxYear = 2100;

  // Bersihkan markup pada isian teks seperti pada EducationForm di web.
  // Tanda perbandingan dalam teks biasa (misalnya "nilai < 80") tetap utuh.
  static final _markup = RegExp(
    r'''<!--[\s\S]*?-->|</?[a-zA-Z][\w:-]*(?=[\s/>])(?:[^<>"']|"[^"]*"|'[^']*')*>''',
  );

  static String plainText(String input) => input.replaceAll(_markup, '').trim();

  static String? schoolName(String? value) {
    final name = value?.trim() ?? '';
    if (plainText(name).isEmpty) {
      return 'Masukkan nama sekolah atau universitas.';
    }
    return _lengthError(name);
  }

  static String? major(String? value) => _lengthError(value?.trim() ?? '');

  static String? _lengthError(String value) {
    // Django menghitung Unicode code point untuk batas panjang CharField.
    return value.runes.length > maxNameLength
        ? 'Gunakan maksimal $maxNameLength karakter.'
        : null;
  }

  static String? startYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Masukkan tahun masuk.';
    }
    return _yearError(value);
  }

  static String? graduationYear(String? value, String startYearText) {
    if (value == null || value.trim().isEmpty) return null;
    final error = _yearError(value);
    if (error != null) return error;

    final start = int.tryParse(startYearText.trim(), radix: 10);
    final end = int.parse(value.trim(), radix: 10);
    if (start != null && start >= minYear && start <= maxYear && end < start) {
      return 'Tahun lulus tidak boleh lebih awal dari tahun masuk.';
    }
    return null;
  }

  static String? _yearError(String value) {
    final year = int.tryParse(value.trim(), radix: 10);
    if (year == null || year < minYear || year > maxYear) {
      return 'Masukkan tahun berupa bilangan bulat antara $minYear dan $maxYear.';
    }
    return null;
  }
}
