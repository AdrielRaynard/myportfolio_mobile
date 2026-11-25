import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

/// Ensures the user is authenticated, pushing [LoginScreen] when needed.
Future<bool> ensureLoggedIn(BuildContext context) async {
  if (context.read<AuthState>().isLoggedIn) return true;
  final loggedIn = await Navigator.push<bool>(
    context,
    MaterialPageRoute<bool>(builder: (_) => const LoginScreen()),
  );
  return loggedIn ?? false;
}

Future<void> logoutWithFeedback(BuildContext context) async {
  final auth = context.read<AuthState>();
  final wasLoggedIn = auth.isLoggedIn;
  if (wasLoggedIn) await auth.logout();
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(wasLoggedIn ? 'Berhasil logout.' : 'Kamu belum login.'),
    ),
  );
}
