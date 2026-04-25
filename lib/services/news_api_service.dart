import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/config/api_config.dart';
import '../models/article.dart';

class NewsApiService {
  const NewsApiService();

  Future<List<Article>> fetchTopHeadlines({
    String country = 'us',
    String? category,
    String? query,
  }) async {
    if (ApiConfig.apiKey == 'YOUR_NEWSAPI_KEY') {
      throw Exception(
        'Missing NewsAPI key. Run with --dart-define=NEWS_API_KEY=your_key_here',
      );
    }

    final params = <String, String>{
      'apiKey': ApiConfig.apiKey,
      'country': country,
      'pageSize': '30',
    };

    if ((category ?? '').isNotEmpty && category != 'all') {
      params['category'] = category!;
    }

    if ((query ?? '').trim().isNotEmpty) {
      params
        ..remove('country')
        ..['q'] = query!.trim();
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}/top-headlines')
        .replace(queryParameters: params);

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch news. Code: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final status = decoded['status'] as String?;

    if (status != 'ok') {
      final apiMessage = decoded['message'] as String? ?? 'Unknown API error';
      throw Exception(apiMessage);
    }

    final articlesJson = (decoded['articles'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();

    final articles = articlesJson
        .map(Article.fromJson)
        .where((article) => article.title.isNotEmpty)
        .toList();

    return articles;
  }
}
