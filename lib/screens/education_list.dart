import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/models/education_history.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

enum _YearOrder { newest, oldest }

class EducationListPage extends StatefulWidget {
  const EducationListPage({super.key});

  @override
  State<EducationListPage> createState() => _EducationListPageState();
}

class _EducationListPageState extends State<EducationListPage> {
  EducationLevel? _level;
  _YearOrder _order = _YearOrder.newest;

  @override
  Widget build(BuildContext context) {
    final entries = EducationHistory.of(context).entries
        .where((entry) => _level == null || entry.level == _level)
        .toList();
    entries.sort((a, b) {
      final byYear = _order == _YearOrder.newest
          ? b.startYear.compareTo(a.startYear)
          : a.startYear.compareTo(b.startYear);
      return byYear == 0 ? a.schoolName.compareTo(b.schoolName) : byYear;
    });
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pendidikan'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      drawer: const LeftDrawer(current: DrawerDestination.educationList),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DropdownButtonFormField<EducationLevel?>(
                  decoration: const InputDecoration(labelText: 'Jenjang'),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Semua')),
                    for (final level in EducationLevel.values)
                      DropdownMenuItem(
                        value: level,
                        child: Text(level.shortLabel),
                      ),
                  ],
                  onChanged: (level) => setState(() => _level = level),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<_YearOrder>(
                  decoration: const InputDecoration(labelText: 'Urutan'),
                  isExpanded: true,
                  initialValue: _YearOrder.newest,
                  items: const [
                    DropdownMenuItem(
                      value: _YearOrder.newest,
                      child: Text('Terbaru ke terlama'),
                    ),
                    DropdownMenuItem(
                      value: _YearOrder.oldest,
                      child: Text('Terlama ke terbaru'),
                    ),
                  ],
                  onChanged: (order) {
                    if (order != null) setState(() => _order = order);
                  },
                ),
                const SizedBox(height: 16),
                if (entries.isEmpty)
                  Text(
                    _level == null
                        ? 'Belum ada riwayat pendidikan.'
                        : 'Belum ada riwayat pendidikan ${_level!.shortLabel}.',
                  ),
                for (final entry in entries) _EducationCard(entry),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard(this.entry);

  final Education entry;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6,
          children: [
            Text(entry.schoolName, style: text.titleMedium),
            Text(
              '${entry.level.shortLabel} · ${entry.startYear}–${entry.graduationYear ?? 'Sekarang'}',
              style: text.labelLarge,
            ),
            if (entry.major != null) Text(entry.major!),
            if (entry.description.isNotEmpty) Text(entry.description),
          ],
        ),
      ),
    );
  }
}
