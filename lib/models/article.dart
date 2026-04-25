class Article {
  const Article({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.content,
    required this.source,
    required this.publishedAt,
    required this.url,
  });

  final String title;
  final String description;
  final String urlToImage;
  final String content;
  final String source;
  final DateTime? publishedAt;
  final String url;

  factory Article.fromJson(Map<String, dynamic> json) {
    final sourceData = json['source'] as Map<String, dynamic>?;

    return Article(
      title: (json['title'] as String?)?.trim().isNotEmpty == true
          ? (json['title'] as String).trim()
          : 'Untitled article',
      description:
          (json['description'] as String?)?.trim() ??
          'No short description available.',
      urlToImage: (json['urlToImage'] as String?)?.trim() ?? '',
      content:
          (json['content'] as String?)?.trim() ??
          'No detailed content available.',
      source: (sourceData?['name'] as String?)?.trim() ?? 'Unknown Source',
      publishedAt: DateTime.tryParse((json['publishedAt'] as String?) ?? ''),
      url: (json['url'] as String?)?.trim() ?? '',
    );
  }
}
