import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

enum DrawerDestination { home, project, education }

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key, required this.current});

  final DrawerDestination current;

  void _navigate(BuildContext context, DrawerDestination destination) {
    final navigator = Navigator.of(context);
    navigator.pop(); // Tutup drawer sebelum berpindah halaman.
    if (destination == current) return;

    if (destination == DrawerDestination.home) {
      navigator.popUntil((route) => route.isFirst);
      return;
    }

    final route = MaterialPageRoute<void>(
      builder: (_) => destination == DrawerDestination.education
          ? const EducationFormPage()
          : const ProjectFormPage(),
    );
    if (current == DrawerDestination.home) {
      navigator.push(route);
    } else {
      navigator.pushReplacement(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const ColoredBox(
            color: Colors.indigo,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Portfolio',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Explore personal projects and experiences!',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            selected: current == DrawerDestination.home,
            onTap: () => _navigate(context, DrawerDestination.home),
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            selected: current == DrawerDestination.project,
            onTap: () => _navigate(context, DrawerDestination.project),
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text('Tambah Pendidikan'),
            selected: current == DrawerDestination.education,
            onTap: () => _navigate(context, DrawerDestination.education),
          ),
        ],
      ),
    );
  }
}
