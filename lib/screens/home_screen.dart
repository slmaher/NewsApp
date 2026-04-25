import 'package:flutter/material.dart';

import '../models/article.dart';
import '../services/news_api_service.dart';
import 'favorites_screen.dart';
import 'news_details_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.favorites,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  final List<Article> favorites;
  final bool Function(Article article) isFavorite;
  final ValueChanged<Article> onToggleFavorite;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

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
        actions: <Widget>[
          IconButton(
            tooltip: 'Favorites',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => FavoritesScreen(
                    favorites: widget.favorites,
                    isFavorite: widget.isFavorite,
                    onToggleFavorite: widget.onToggleFavorite,
                  ),
                ),
              ).then((_) => setState(() {}));
            },
            icon: const Icon(Icons.favorite_outline_rounded),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => SettingsScreen(
                    isDarkMode: widget.isDarkMode,
                    onThemeChanged: widget.onThemeChanged,
                  ),
                ),
              ).then((_) => setState(() {}));
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
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
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<List<Article>> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return _ErrorState(
                          message: snapshot.error.toString().replaceFirst(
                            'Exception: ',
                            '',
                          ),
                          onRetry: _refreshNews,
                        );
                      }

                      final List<Article> articles =
                          snapshot.data ?? <Article>[];
                      if (articles.isEmpty) {
                        return const _EmptyState();
                      }

                      return RefreshIndicator(
                        onRefresh: _pullToRefresh,
                        child: LayoutBuilder(
                          builder:
                              (
                                BuildContext context,
                                BoxConstraints constraints,
                              ) {
                                final bool isWide = constraints.maxWidth > 700;
                                final bool isCompact =
                                    constraints.maxWidth < 360;
                                final double horizontalPadding = isCompact
                                    ? 8
                                    : 12;
                                final double cardMaxWidth = isWide
                                    ? 720
                                    : constraints.maxWidth;

                                return ListView.builder(
                                  padding: EdgeInsets.fromLTRB(
                                    horizontalPadding,
                                    8,
                                    horizontalPadding,
                                    20,
                                  ),
                                  itemCount: articles.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                        final Article article = articles[index];

                                        return Center(
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: cardMaxWidth,
                                            ),
                                            child: _NewsCard(
                                              article: article,
                                              compact: isCompact,
                                              isFavorite: widget.isFavorite(
                                                article,
                                              ),
                                              onToggleFavorite: () =>
                                                  widget.onToggleFavorite(
                                                    article,
                                                  ),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute<void>(
                                                    builder: (_) => NewsDetailsScreen(
                                                      article: article,
                                                      isFavorite: widget
                                                          .isFavorite(article),
                                                      onToggleFavorite: () =>
                                                          widget
                                                              .onToggleFavorite(
                                                                article,
                                                              ),
                                                    ),
                                                  ),
                                                ).then((_) => setState(() {}));
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
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isCompact = screenWidth < 360;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isCompact ? 8 : 12,
        8,
        isCompact ? 8 : 12,
        6,
      ),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onSubmitted: onSearch,
        style: TextStyle(fontSize: isCompact ? 14 : 15),
        decoration: InputDecoration(
          hintText: 'Search by keyword',
          hintStyle: TextStyle(fontSize: isCompact ? 14 : 15),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: isCompact ? 11 : 13),
          prefixIcon: Icon(Icons.search_rounded, size: isCompact ? 20 : 22),
          suffixIcon: IconButton(
            onPressed: onClear,
            icon: Icon(Icons.close_rounded, size: isCompact ? 20 : 22),
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
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isCompact = screenWidth < 360;
    final bool useTwoRows = screenWidth <= 600;

    Widget buildChip(String category) {
      final bool isSelected = category == selectedCategory;

      return ChoiceChip(
        label: Text(
          category[0].toUpperCase() + category.substring(1),
          style: TextStyle(fontSize: isCompact ? 12 : 13),
        ),
        visualDensity: isCompact
            ? const VisualDensity(horizontal: -2, vertical: -2)
            : VisualDensity.standard,
        selected: isSelected,
        onSelected: (_) => onCategorySelected(category),
      );
    }

    if (useTwoRows) {
      return Padding(
        padding: EdgeInsets.fromLTRB(isCompact ? 8 : 12, 0, isCompact ? 8 : 12, 6),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: isCompact ? 6 : 8,
            runSpacing: isCompact ? 6 : 8,
            children: categories.map(buildChip).toList(),
          ),
        ),
      );
    }

    return SizedBox(
      height: isCompact ? 44 : 48,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: isCompact ? 8 : 12),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final String category = categories[index];

          return Padding(
            padding: EdgeInsets.only(right: isCompact ? 6 : 8),
            child: buildChip(category),
          );
        },
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({
    required this.article,
    required this.onTap,
    required this.onToggleFavorite,
    required this.isFavorite,
    this.compact = false,
  });

  final Article article;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final bool isFavorite;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final double imageWidth = compact ? 88 : 110;
    final double imageHeight = compact ? 80 : 90;

    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: compact ? 10 : 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(compact ? 10 : 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(compact ? 10 : 12),
                child: SizedBox(
                  height: imageHeight,
                  width: imageWidth,
                  child: article.urlToImage.isNotEmpty
                      ? Image.network(
                          article.urlToImage,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (
                                BuildContext context,
                                Object error,
                                StackTrace? stackTrace,
                              ) => _imagePlaceholder(),
                        )
                      : _imagePlaceholder(),
                ),
              ),
              SizedBox(width: compact ? 10 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      article.title,
                      maxLines: compact ? 3 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: compact ? 15 : 16,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: compact ? 4 : 6),
                    Text(
                      article.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: compact ? 12 : 13,
                        height: 1.3,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: isFavorite
                            ? 'Remove from favorites'
                            : 'Add to favorites',
                        onPressed: onToggleFavorite,
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite
                              ? Theme.of(context).colorScheme.error
                              : null,
                          size: compact ? 20 : 22,
                        ),
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
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Colors.redAccent,
            ),
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
