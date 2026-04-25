import 'package:flutter/material.dart';

import 'models/article.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});

  @override
  State<NewsApp> createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  ThemeMode _themeMode = ThemeMode.light;
  final List<Article> _favorites = <Article>[];

  bool isFavorite(Article article) {
    return _favorites.any((Article item) => item.url == article.url);
  }

  void toggleFavorite(Article article) {
    setState(() {
      if (isFavorite(article)) {
        _favorites.removeWhere((Article item) => item.url == article.url);
      } else {
        _favorites.insert(0, article);
      }
    });
  }

  void updateThemeMode(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F8FB),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF0D1B2A),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0F1722),
        cardTheme: CardThemeData(
          elevation: 0,
          color: const Color(0xFF1B2432),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      home: HomeScreen(
        favorites: _favorites,
        isDarkMode: _themeMode == ThemeMode.dark,
        isFavorite: isFavorite,
        onToggleFavorite: toggleFavorite,
        onThemeChanged: updateThemeMode,
      ),
    );
  }
}
