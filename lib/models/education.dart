/// Nilai [code] mengikuti pilihan yang tersimpan pada model Education di web.
enum EducationLevel {
  smp('smp', 'SMP'),
  sma('sma', 'SMA/SMK'),
  s1('S1', 'S1 (Sarjana)'),
  s2('S2', 'S2 (Magister)'),
  s3('S3', 'S3 (Doktor)');

  const EducationLevel(this.code, this.label);

  final String code;
  final String label;

  String get shortLabel => switch (this) {
    smp || sma => label,
    s1 || s2 || s3 => code,
  };
}

class Education {
  const Education({
    required this.schoolName,
    required this.level,
    required this.startYear,
    this.major,
    this.graduationYear,
    this.description = '',
  });

  final String schoolName;
  final EducationLevel level;
  final String? major;
  final int startYear;

  /// Kosong selama pendidikan masih berlangsung, sama seperti tahun_lulus di web.
  final int? graduationYear;
  final String description;
}
