/// Base URL of the Django REST Framework backend.
///
/// The default reaches the development machine from the Android emulator.
/// For Chrome, use `--dart-define=API_BASE_URL=http://localhost:8000`.
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);
