import 'package:flutter/widgets.dart';
import 'package:myportofolio_mobile/models/education.dart';

/// Riwayat untuk seluruh halaman dalam satu sesi aplikasi.
class EducationHistory extends InheritedWidget {
  const EducationHistory({
    super.key,
    required this.entries,
    required this.add,
    required super.child,
  });

  final List<Education> entries;
  final ValueChanged<Education> add;

  static EducationHistory of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<EducationHistory>()!;

  @override
  bool updateShouldNotify(EducationHistory oldWidget) =>
      entries != oldWidget.entries;
}

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
