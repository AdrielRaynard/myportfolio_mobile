import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:provider/provider.dart';

class EducationDetailScreen extends StatefulWidget {
  const EducationDetailScreen({super.key, required this.education});

  final Education education;

  @override
  State<EducationDetailScreen> createState() => _EducationDetailScreenState();
}

class _EducationDetailScreenState extends State<EducationDetailScreen> {
  late Future<Education> _detail;

  @override
  void initState() {
    super.initState();
    _detail = _load();
  }

  Future<Education> _load() {
    final id = widget.education.id;
    return id == null
        ? Future.value(widget.education)
        : context.read<ApiClient>().getEducation(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pendidikan')),
      body: SafeArea(
        child: FutureBuilder<Education>(
          future: _detail,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              final missing =
                  snapshot.error is ApiException &&
                  (snapshot.error as ApiException).statusCode == 404;
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      missing
                          ? 'Entri pendidikan tidak ditemukan.'
                          : 'Gagal memuat detail pendidikan.',
                    ),
                    TextButton(
                      onPressed: () {
                        final future = _load();
                        setState(() {
                          _detail = future;
                        });
                      },
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              );
            }
            return _content(snapshot.requireData);
          },
        ),
      ),
    );
  }

  Widget _content(Education education) {
    final text = Theme.of(context).textTheme;
    final imageUrl = education.educationImageUrl.trim();
    final fields = {
      'ID': education.id ?? 'Tidak tersedia',
      'Jenjang': education.level.label,
      'Tahun masuk': education.startYear.toString(),
      'Tahun lulus': education.graduationYear?.toString() ?? 'Sekarang',
      'Jurusan': (education.major ?? '').isEmpty
          ? 'Tidak diisi'
          : education.major!,
      'Deskripsi': education.description.isEmpty
          ? 'Tidak diisi'
          : education.description,
      'Jumlah bintang': education.starCount.toString(),
      'Status bintang pada respons API': education.isStarred
          ? 'Dibintangi'
          : 'Tidak dibintangi',
      'Dibintangi oleh': education.starredByNames.isEmpty
          ? 'Belum ada'
          : education.starredByNames,
    };
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(education.schoolName, style: text.headlineSmall),
        if (imageUrl.isNotEmpty)
          Image.network(
            imageUrl,
            height: 200,
            fit: BoxFit.contain,
            semanticLabel: 'Gambar ${education.schoolName}',
            errorBuilder: (_, _, _) => const Text('Gambar gagal dimuat.'),
          ),
        for (final field in fields.entries)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(field.key),
            subtitle: Text(field.value),
          ),
      ],
    );
  }
}
