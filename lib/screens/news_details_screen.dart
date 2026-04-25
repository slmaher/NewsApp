import 'package:flutter/material.dart';

import '../models/article.dart';

class NewsDetailsScreen extends StatelessWidget {
  const NewsDetailsScreen({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final String formattedDate = article.publishedAt == null
        ? 'Unknown publish date'
        : '${article.publishedAt!.year}-${article.publishedAt!.month.toString().padLeft(2, '0')}-${article.publishedAt!.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(title: const Text('Article Details')),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool isWide = constraints.maxWidth > 700;

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWide ? 760 : constraints.maxWidth,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 220,
                        width: double.infinity,
                        child: article.urlToImage.isNotEmpty
                            ? Image.network(
                                article.urlToImage,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (
                                      BuildContext context,
                                      Object error,
                                      StackTrace? stackTrace,
                                    ) => _bannerPlaceholder(),
                              )
                            : _bannerPlaceholder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        _MetaChip(
                          icon: Icons.public_rounded,
                          text: article.source,
                        ),
                        _MetaChip(
                          icon: Icons.calendar_today_rounded,
                          text: formattedDate,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.description,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Content',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _sanitizeContent(article.content),
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.grey.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _bannerPlaceholder() {
    return Container(
      color: const Color(0xFFE8EEF5),
      child: const Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 48,
          color: Colors.black45,
        ),
      ),
    );
  }

  String _sanitizeContent(String rawContent) {
    final int markerIndex = rawContent.indexOf('[+');
    if (markerIndex == -1) {
      return rawContent;
    }
    return rawContent.substring(0, markerIndex).trim();
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: const Color(0xFF184A8B)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF184A8B),
            ),
          ),
        ],
      ),
    );
  }
}
