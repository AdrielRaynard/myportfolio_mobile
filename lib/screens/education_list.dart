import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/education_detail_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

enum _YearOrder { newest, oldest }

class EducationListPage extends StatefulWidget {
  const EducationListPage({super.key});

  @override
  State<EducationListPage> createState() => _EducationListPageState();
}

class _EducationListPageState extends State<EducationListPage> {
  EducationLevel? _level;
  _YearOrder _order = _YearOrder.newest;

  late Future<List<Education>> _educationsFuture;

  @override
  void initState() {
    super.initState();
    _educationsFuture = context.read<ApiClient>().getEducations();
  }

  Future<void> _reload() async {
    final future = context.read<ApiClient>().getEducations();
    setState(() {
      _educationsFuture = future;
    });
    try {
      await future;
    } catch (_) {
      // FutureBuilder menampilkan kegagalan, termasuk saat tarik untuk memuat ulang.
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: FutureBuilder<List<Education>>(
              future: _educationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  final message = switch (snapshot.error) {
                    ApiException(statusCode: 401 || 403) =>
                      'Akses ke daftar pendidikan ditolak.',
                    ApiException(statusCode: >= 500) =>
                      'Server sedang bermasalah. Coba lagi nanti.',
                    _ => 'Gagal memuat daftar pendidikan. Periksa koneksi dan coba lagi.',
                  };
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(message, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _reload,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba lagi'),
                        ),
                      ],
                    ),
                  );
                }
                return _list(snapshot.requireData);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _list(List<Education> remote) {
    final entries = remote
        .where((entry) => _level == null || entry.level == _level)
        .toList();
    entries.sort((a, b) {
      final byYear = _order == _YearOrder.newest
          ? b.startYear.compareTo(a.startYear)
          : a.startYear.compareTo(b.startYear);
      return byYear == 0 ? a.schoolName.compareTo(b.schoolName) : byYear;
    });
    return RefreshIndicator(
      onRefresh: _reload,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
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
                ],
              ),
            ),
          ),
          if (entries.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  _level == null
                      ? 'Belum ada riwayat pendidikan.'
                      : 'Belum ada riwayat pendidikan ${_level!.shortLabel}.',
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverList.builder(
                itemCount: entries.length,
                itemBuilder: (_, index) => _EducationCard(entries[index]),
              ),
            ),
        ],
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
      child: InkWell(
        onTap: () => Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (_) => EducationDetailScreen(education: entry),
          ),
        ),
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
      ),
    );
  }
}
