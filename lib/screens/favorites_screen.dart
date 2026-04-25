import 'package:flutter/material.dart';

import '../models/article.dart';
import 'news_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({
    super.key,
    required this.favorites,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final List<Article> favorites;
  final bool Function(Article article) isFavorite;
  final ValueChanged<Article> onToggleFavorite;

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  void _toggleFavorite(Article article) {
    setState(() {
      widget.onToggleFavorite(article);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: SafeArea(
        child: widget.favorites.isEmpty
            ? const _EmptyFavoritesState()
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
                itemCount: widget.favorites.length,
                itemBuilder: (BuildContext context, int index) {
                  final Article article = widget.favorites[index];
                  final bool favorite = widget.isFavorite(article);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 56,
                          height: 56,
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
                      title: Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        article.source,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        tooltip: 'Remove from favorites',
                        onPressed: () => _toggleFavorite(article),
                        icon: Icon(
                          favorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: favorite
                              ? Theme.of(context).colorScheme.error
                              : null,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => NewsDetailsScreen(
                              article: article,
                              isFavorite: widget.isFavorite(article),
                              onToggleFavorite: () => _toggleFavorite(article),
                            ),
                          ),
                        ).then((_) => setState(() {}));
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: const Color(0xFFE8EEF5),
      child: const Icon(Icons.image_not_supported_outlined, size: 20),
    );
  }
}

class _EmptyFavoritesState extends StatelessWidget {
  const _EmptyFavoritesState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(
              Icons.favorite_outline_rounded,
              size: 54,
              color: Colors.black45,
            ),
            SizedBox(height: 12),
            Text(
              'No favorites yet. Save articles using the heart icon.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
