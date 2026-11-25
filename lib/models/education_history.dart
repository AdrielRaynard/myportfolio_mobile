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
