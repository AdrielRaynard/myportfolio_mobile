import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/validation/education_validators.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _school = TextEditingController();
  final _major = TextEditingController();
  final _start = TextEditingController();
  final _graduation = TextEditingController();
  final _description = TextEditingController();
  EducationLevel _level = EducationLevel.s1;
  bool _saving = false;

  @override
  void dispose() {
    _school.dispose();
    _major.dispose();
    _start.dispose();
    _graduation.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final major = EducationValidators.plainText(_major.text);
    final education = Education(
      schoolName: EducationValidators.plainText(_school.text),
      level: _level,
      major: major.isEmpty ? null : major,
      startYear: int.parse(_start.text.trim(), radix: 10),
      graduationYear: int.tryParse(_graduation.text.trim(), radix: 10),
      description: EducationValidators.plainText(_description.text),
    );
    setState(() => _saving = true);
    try {
      if (!await ensureLoggedIn(context) || !mounted) return;
      final token = context.read<AuthState>().token;
      if (token == null) return;
      final saved = await context.read<ApiClient>().createEducation(
        education,
        token: token,
      );
      if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
      await showDialog<void>(
        context: context,
        builder: (_) => _EducationSummary(education: saved),
      );
    } on ApiException catch (error) {
      if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
      if (error.statusCode == 401) {
        await context.read<AuthState>().logout();
        if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
        final loggedIn = await ensureLoggedIn(context);
        if (!mounted) return;
        if (!loggedIn) {
          Navigator.of(context).maybePop();
          return;
        }
        _message('Login berhasil. Tekan Simpan untuk mengirim ulang.');
      } else {
        _message('Gagal menyimpan pendidikan (HTTP ${error.statusCode}).');
      }
    } on http.ClientException {
      if (mounted) _message('Gagal terhubung ke server. Coba lagi.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _message(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  InputDecoration _decoration(String label, {String? hint, String? help}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: help,
      helperMaxLines: 3,
      errorMaxLines: 3,
      border: const OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pendidikan'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      drawer: const LeftDrawer(current: DrawerDestination.education),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 16,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _school,
                      decoration: _decoration(
                        'Nama Sekolah / Universitas',
                        hint: 'Universitas Indonesia',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: EducationValidators.schoolName,
                    ),
                    DropdownButtonFormField<EducationLevel>(
                      decoration: _decoration('Tingkat Pendidikan'),
                      initialValue: EducationLevel.s1,
                      isExpanded: true,
                      items: [
                        for (final level in EducationLevel.values)
                          DropdownMenuItem(
                            value: level,
                            child: Text(level.label),
                          ),
                      ],
                      onChanged: (level) {
                        if (level != null) _level = level;
                      },
                    ),
                    TextFormField(
                      controller: _major,
                      decoration: _decoration(
                        'Jurusan (opsional)',
                        hint: 'Sistem Informasi',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: EducationValidators.major,
                    ),
                    TextFormField(
                      controller: _start,
                      decoration: _decoration('Tahun Masuk', hint: '2025'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: EducationValidators.startYear,
                    ),
                    TextFormField(
                      controller: _graduation,
                      decoration: _decoration(
                        'Tahun Lulus (opsional)',
                        hint: '2029',
                        help: 'Kosongkan jika masih menempuh pendidikan.',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) => EducationValidators.graduationYear(
                        value,
                        _start.text,
                      ),
                    ),
                    TextFormField(
                      controller: _description,
                      decoration: _decoration(
                        'Deskripsi Pendidikan (opsional)',
                      ),
                      minLines: 3,
                      maxLines: 6,
                    ),
                    FilledButton(
                      onPressed: _saving ? null : _submit,
                      child: Text(_saving ? 'Menyimpan…' : 'Simpan'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EducationSummary extends StatelessWidget {
  const _EducationSummary({required this.education});

  final Education education;

  @override
  Widget build(BuildContext context) {
    final fields = {
      'Nama Sekolah / Universitas': education.schoolName,
      'Tingkat Pendidikan': education.level.label,
      'Jurusan': education.major ?? 'Tidak diisi',
      'Tahun Masuk': education.startYear.toString(),
      'Tahun Lulus': education.graduationYear?.toString() ?? 'Sekarang',
      'Deskripsi Pendidikan': education.description.isEmpty
          ? 'Tidak diisi'
          : education.description,
    };
    return AlertDialog(
      title: const Text('Ringkasan Pendidikan'),
      scrollable: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text('Riwayat pendidikan berhasil disimpan.'),
          ),
          for (final field in fields.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${field.key}\n',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    TextSpan(text: field.value),
                  ],
                ),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
      ],
    );
  }
}
