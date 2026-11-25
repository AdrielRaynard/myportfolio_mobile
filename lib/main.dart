import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({this.apiClient, super.key});

  final ApiClient? apiClient;

  @override
  Widget build(BuildContext context) {
    final client = apiClient ?? context.watch<ApiClient?>();
    return MultiProvider(
      providers: [
        if (client != null)
          Provider<ApiClient>.value(value: client)
        else
          Provider<ApiClient>(
            create: (_) => ApiClient(),
            dispose: (_, client) => client.close(),
          ),
        ChangeNotifierProvider<AuthState>(
          create: (context) => AuthState(context.read<ApiClient>()),
        ),
      ],
      child: MaterialApp(
        title: 'MyPortfolio',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            secondary: Colors.amber,
          ),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
