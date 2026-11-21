import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

/// Halaman utama yang menampilkan profil dan menu aksi portofolio.
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  static const String _npm = '2506587150';
  static const String _nama = 'Adriel Raynard Davis Sihotang';
  static const String _kelas = 'PBP B';

  static const List<ItemHomepage> _items = <ItemHomepage>[
    ItemHomepage(
      name: 'Lihat Proyek',
      icon: Icons.folder_outlined,
      color: Colors.indigo,
      action: PortfolioAction.showFeedback,
    ),
    ItemHomepage(
      name: 'Tambah Proyek',
      icon: Icons.add_circle_outline,
      color: Colors.teal,
      action: PortfolioAction.showFeedback,
    ),
    ItemHomepage(
      name: 'Logout',
      icon: Icons.logout,
      color: Colors.deepOrange,
      action: PortfolioAction.showFeedback,
    ),
    ItemHomepage(
      name: 'Tentang Portofolio',
      icon: Icons.account_circle_outlined,
      color: Colors.blueGrey,
      action: PortfolioAction.showOverview,
    ),
    ItemHomepage(
      name: 'Tambah Pendidikan',
      icon: Icons.school_outlined,
      color: Colors.deepPurple,
      action: PortfolioAction.addEducation,
    ),
  ];

  void _handleItemTap(BuildContext context, ItemHomepage item) {
    switch (item.action) {
      case PortfolioAction.addEducation:
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(builder: (_) => const EducationFormPage()),
        );
        return;
      case PortfolioAction.showFeedback:
        _showActionFeedback(context, item);
        return;
      case PortfolioAction.showOverview:
        _showActionFeedback(context, item);
        _showPortfolioOverview(context);
        return;
    }
  }

  void _showActionFeedback(BuildContext context, ItemHomepage item) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Kamu telah menekan tombol ${item.name}!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _showPortfolioOverview(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => const PortfolioOverviewSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(current: DrawerDestination.home),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                    child: InfoCard(title: 'NPM', content: _npm),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: InfoCard(title: 'Name', content: _nama),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: InfoCard(title: 'Class', content: _kelas),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Text(
                'Selamat datang di MyPortfolio Mobile!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Menu Portofolio',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final bool isWideScreen = constraints.maxWidth >= 600;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _items.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWideScreen ? 4 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: isWideScreen ? 1 : 1.25,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final ItemHomepage item = _items[index];
                      return ItemCard(
                        item: item,
                        onTap: () => _handleItemTap(context, item),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(content, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// Menentukan respons saat kartu aksi pada halaman utama ditekan.
enum PortfolioAction { showFeedback, showOverview, addEducation }

/// Model data untuk satu aksi pada halaman utama.
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;
  final PortfolioAction action;

  const ItemHomepage({
    required this.name,
    required this.icon,
    required this.color,
    required this.action,
  });
}

/// Bottom sheet yang menyajikan ringkasan singkat portofolio pemilik aplikasi.
class PortfolioOverviewSheet extends StatelessWidget {
  const PortfolioOverviewSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                  child: const Icon(Icons.account_circle_outlined),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Ringkasan Portofolio',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'MyPortfolio Mobile adalah ruang awal untuk menyajikan profil '
              'dan mengembangkan koleksi proyek pribadi secara bertahap.',
            ),
            const SizedBox(height: 16),
            const PortfolioDetail(
              icon: Icons.person_outline,
              label: 'Pemilik',
              value: 'Adriel Raynard Davis Sihotang',
            ),
            const PortfolioDetail(
              icon: Icons.badge_outlined,
              label: 'Identitas',
              value: '2506587150 - PBP B',
            ),
            const SizedBox(height: 8),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('Flutter')),
                Chip(label: Text('Material 3')),
                Chip(label: Text('PBP')),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
              label: const Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Baris informasi ringkas di dalam [PortfolioOverviewSheet].
class PortfolioDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const PortfolioDetail({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
