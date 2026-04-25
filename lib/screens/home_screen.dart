import 'package:flutter/material.dart';

import '../models/article.dart';
import '../services/news_api_service.dart';
import 'news_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<String> _categories = <String>[
    'all',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];

  final NewsApiService _newsApiService = const NewsApiService();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<Article>> _articlesFuture;
  String _selectedCategory = 'all';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _articlesFuture = _fetchArticles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Article>> _fetchArticles() {
    return _newsApiService.fetchTopHeadlines(
      country: 'us',
      category: _selectedCategory,
      query: _searchQuery,
    );
  }

  void _refreshNews() {
    setState(() {
      _articlesFuture = _fetchArticles();
    });
  }

  Future<void> _pullToRefresh() async {
    _refreshNews();
    await _articlesFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
      ),
      body: Column(
        children: <Widget>[
          _SearchBar(
            controller: _searchController,
            onSearch: (String value) {
              _searchQuery = value.trim();
              _refreshNews();
            },
            onClear: () {
              _searchController.clear();
              _searchQuery = '';
              _refreshNews();
            },
          ),
          _CategoryFilter(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: (String category) {
              setState(() {
                _selectedCategory = category;
                _articlesFuture = _fetchArticles();
              });
            },
          ),
          Expanded(
            child: FutureBuilder<List<Article>>(
              future: _articlesFuture,
              builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return _ErrorState(
                    message: snapshot.error.toString().replaceFirst('Exception: ', ''),
                    onRetry: _refreshNews,
                  );
                }

                final List<Article> articles = snapshot.data ?? <Article>[];
                if (articles.isEmpty) {
                  return const _EmptyState();
                }

                return RefreshIndicator(
                  onRefresh: _pullToRefresh,
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final bool isWide = constraints.maxWidth > 700;
                      final double cardMaxWidth = isWide ? 720 : constraints.maxWidth;

                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
                        itemCount: articles.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Article article = articles[index];

                          return Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: cardMaxWidth),
                              child: _NewsCard(
                                article: article,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (_) => NewsDetailsScreen(article: article),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onSearch,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onSubmitted: onSearch,
        decoration: InputDecoration(
          hintText: 'Search by keyword',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: IconButton(
            onPressed: onClear,
            icon: const Icon(Icons.close_rounded),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final String category = categories[index];
          final bool isSelected = category == selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category[0].toUpperCase() + category.substring(1)),
              selected: isSelected,
              onSelected: (_) => onCategorySelected(category),
            ),
          );
        },
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.article, required this.onTap});

  final Article article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 90,
                  width: 110,
                  child: article.urlToImage.isNotEmpty
                      ? Image.network(
                          article.urlToImage,
                          fit: BoxFit.cover,
                          errorBuilder: (
                            BuildContext context,
                            Object error,
                            StackTrace? stackTrace,
                          ) => _imagePlaceholder(),
                        )
                      : _imagePlaceholder(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: const Color(0xFFE8EEF5),
      child: const Icon(Icons.image_not_supported_outlined, size: 28),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(Icons.newspaper_outlined, size: 48, color: Colors.black45),
            SizedBox(height: 12),
            Text(
              'No articles found for this filter.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
