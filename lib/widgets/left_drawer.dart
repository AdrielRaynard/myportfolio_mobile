import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/education_list.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

enum DrawerDestination { home, project, education, educationList }

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key, required this.current});

  final DrawerDestination current;

  Future<void> _navigate(
    BuildContext context,
    DrawerDestination destination,
  ) async {
    final navigator = Navigator.of(context);
    navigator.pop(); // Tutup drawer sebelum berpindah halaman.
    if (destination == current) return;

    final Widget page;
    switch (destination) {
      case DrawerDestination.home:
        navigator.popUntil((route) => route.isFirst);
        return;
      case DrawerDestination.education:
        if (!await ensureLoggedIn(context) || !context.mounted) return;
        page = const EducationFormPage();
      case DrawerDestination.project:
        page = const ProjectFormPage();
      case DrawerDestination.educationList:
        page = const EducationListPage();
    }
    final route = MaterialPageRoute<void>(builder: (_) => page);
    if (current == DrawerDestination.home) {
      navigator.push(route);
    } else {
      navigator.pushReplacement(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
    final pageContext = Scaffold.of(context).context;
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
            onTap: () => _navigate(pageContext, DrawerDestination.education),
          ),
          ListTile(
            leading: const Icon(Icons.list_alt_outlined),
            title: const Text('Daftar Pendidikan'),
            selected: current == DrawerDestination.educationList,
            onTap: () => _navigate(context, DrawerDestination.educationList),
          ),
          ListTile(
            leading: Icon(isLoggedIn ? Icons.logout : Icons.login),
            title: Text(isLoggedIn ? 'Logout' : 'Login'),
            onTap: () async {
              Navigator.pop(context);
              if (!isLoggedIn) {
                await ensureLoggedIn(pageContext);
                return;
              }
              await logoutWithFeedback(pageContext);
              if (current == DrawerDestination.education &&
                  pageContext.mounted) {
                Navigator.of(pageContext).popUntil((route) => route.isFirst);
              }
            },
          ),
        ],
      ),
    );
  }
}
