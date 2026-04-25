class ApiConfig {
  static const String baseUrl = 'https://newsapi.org/v2';

  // Pass your key with: flutter run --dart-define=NEWS_API_KEY=your_key_here
  static const String apiKey = String.fromEnvironment(
    'NEWS_API_KEY',
    defaultValue: 'YOUR_NEWSAPI_KEY',
  );
}
