import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';

class EducationDetailScreen extends StatelessWidget {
  const EducationDetailScreen({super.key, required this.education});

  final Education education;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final imageUrl = education.educationImageUrl.trim();
    final fields = {
      'Jenjang': education.level.label,
      'Tahun masuk': education.startYear.toString(),
      'Tahun lulus': education.graduationYear?.toString() ?? 'Sekarang',
      if (education.major?.isNotEmpty == true) 'Jurusan': education.major!,
      if (education.description.isNotEmpty) 'Deskripsi': education.description,
      'Jumlah bintang': education.starCount.toString(),
      if (education.starredByNames.isNotEmpty)
        'Dibintangi oleh': education.starredByNames,
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pendidikan')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(education.schoolName, style: text.headlineSmall),
            if (imageUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  fit: BoxFit.contain,
                  semanticLabel: 'Gambar ${education.schoolName}',
                  errorBuilder: (_, _, _) => const Text('Gambar gagal dimuat.'),
                ),
              ),
            for (final field in fields.entries)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(field.key),
                subtitle: Text(field.value),
              ),
          ],
        ),
      ),
    );
  }
}
