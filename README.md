# News App

A complete Flutter mobile news application built for an advanced Mobile Computing project.
The app consumes real-time headlines from NewsAPI and demonstrates clean structure,
API integration, async state management, responsive UI behavior, and secure key handling.

## 1. Project Overview

News App is designed to showcase practical mobile development concepts:

1. Multi-screen app flow with navigation.
2. Real REST API integration using the http package.
3. JSON decoding and model mapping with fromJson.
4. Async rendering with FutureBuilder.
5. Full loading, empty, and error state handling.
6. Responsive UI adaptation for small mobile screens.
7. Optional advanced features: category filter, keyword search, pull-to-refresh.

## 2. Implemented Features

1. Home screen with article feed.
2. Details screen with larger media and full article info.
3. Category filtering (All, Business, Entertainment, Health, Science, Sports, Technology).
4. Keyword search integrated with the NewsAPI query parameter.
5. Pull-to-refresh using RefreshIndicator.
6. Graceful fallback for missing images and missing text fields.
7. User-friendly error messages with retry action.

## 3. Tech Stack

1. Framework: Flutter
2. Language: Dart
3. HTTP client: http
4. Remote API: NewsAPI (https://newsapi.org)
5. UI system: Material 3

## 4. Project Structure

The app follows a clean, layered folder organization:

1. lib/main.dart
   App entry point, app theme, root widget.
2. lib/core/config/api_config.dart
   API constants and secure key retrieval using dart-define.
3. lib/models/article.dart
   Article entity and JSON parsing logic.
4. lib/services/news_api_service.dart
   API request construction, response decoding, and error handling.
5. lib/screens/home_screen.dart
   Home UI, search, category filter, article list, refresh, loading/error/empty states.
6. lib/screens/news_details_screen.dart
   Detailed article view with responsive content rendering.

## 5. Architecture and Data Flow

### 5.1 High-level flow

1. App starts in main.dart and loads HomeScreen.
2. HomeScreen requests articles through NewsApiService.
3. NewsApiService calls NewsAPI and returns a List of Article.
4. FutureBuilder renders one of these states:
   loading, error, empty, or data list.
5. Tapping a card navigates to NewsDetailsScreen with Navigator.push.

### 5.2 Service layer behavior

NewsApiService performs:

1. API key validation.
2. Query parameter construction based on selected category and search term.
3. HTTP GET request.
4. JSON decoding with jsonDecode.
5. API status validation and error propagation.
6. Mapping raw article JSON to typed Article model objects.

### 5.3 Model mapping behavior

Article.fromJson handles nullable and missing fields by providing defaults:

1. Missing title => Untitled article
2. Missing description => No short description available.
3. Missing content => No detailed content available.
4. Missing source => Unknown Source
5. Invalid publishedAt => null

This ensures UI stability even with incomplete API data.

## 6. UI/UX Design Notes

### 6.1 Home screen

1. Search bar at top for keyword lookup.
2. Category chips below search.
3. Multi-state article feed:
   loading spinner, error panel, empty panel, or list view.
4. Card layout includes:
   thumbnail, title, short description.

### 6.2 Detail screen

1. Large article image banner.
2. Prominent title text.
3. Metadata chips for source and published date.
4. Dedicated Description and Content sections.

### 6.3 Responsiveness

The app includes adaptive behavior for small mobile screens:

1. Compact spacing and typography on narrow widths.
2. Adaptive card dimensions and text constraints.
3. Category chips wrap into multiple rows on mobile widths.
4. Detail screen image height scales by available width.

## 7. API Integration Details

Endpoint used:

1. /v2/top-headlines

Default request behavior:

1. country=us
2. pageSize=30
3. apiKey from dart-define

Conditional request behavior:

1. category is sent when selected category is not all.
2. q is sent for keyword search; in this mode country is removed to match API usage.

Core parsed fields:

1. title
2. description
3. urlToImage
4. content
5. source.name
6. publishedAt
7. url

## 8. Secure API Key Handling

This project is configured to avoid hardcoding secrets in source code.

### 8.1 Recommended run method

Use runtime injection:

  flutter run --dart-define=NEWS_API_KEY=YOUR_REAL_KEY

### 8.2 Local file method

Create a local file named .env.json:

  {
    "NEWS_API_KEY": "YOUR_REAL_KEY"
  }

Run with:

  flutter run --dart-define-from-file=.env.json

### 8.3 Git safety

Never commit real API keys.
If a key was exposed at any point, rotate/regenerate it in NewsAPI dashboard.

## 9. Setup and Run Guide

### 9.1 Prerequisites

1. Flutter SDK installed and configured
2. Dart SDK (bundled with Flutter)
3. Android Studio or VS Code with Flutter extensions
4. Emulator or physical Android/iOS device
5. A valid NewsAPI key

### 9.2 Installation

1. Clone the repository
2. Open project root
3. Run:

  flutter pub get

### 9.3 Running the app

1. Check devices:

  flutter devices

2. Launch:

  flutter run --dart-define=NEWS_API_KEY=YOUR_REAL_KEY

## 10. Testing and Code Quality

This project includes baseline validation steps:

1. Static analysis:

  flutter analyze

2. Widget tests:

  flutter test

Current status during development:

1. Analyzer: no issues
2. Tests: pass

## 11. Error Handling Strategy

The app handles failure scenarios at multiple levels:

1. Missing key detection before API call.
2. Non-200 HTTP response handling.
3. NewsAPI status validation.
4. User-visible retry option on failure.
5. Empty list feedback when no matching articles exist.
6. Image error builders for broken or missing image URLs.

## 12. Known Limitations

1. NewsAPI free tier may have request limits.
2. Some article content from providers is truncated by source.
3. Full article reading in-app is not implemented yet (URL is available in model).

## 13. Suggested Future Enhancements

1. In-app article web view (webview_flutter or url_launcher).
2. Local caching and offline reading mode.
3. Bookmark or favorites persistence.
4. Pagination / infinite scroll.
5. State management upgrade (Provider, Riverpod, Bloc).
6. Unit and integration test expansion.

## 14. Rubric Mapping (College Project)

This implementation satisfies typical advanced mobile computing requirements:

1. Clean architecture style folder separation.
2. API integration with asynchronous rendering.
3. Model-based JSON parsing with fromJson.
4. Multi-screen navigation with argument passing.
5. Functional loading/error/empty UI states.
6. Responsive mobile layout improvements.
7. Security-conscious secret management workflow.

## 15. Quick Command Reference

1. Get packages:

  flutter pub get

2. Analyze project:

  flutter analyze

3. Run tests:

  flutter test

4. Run app with API key:

  flutter run --dart-define=NEWS_API_KEY=YOUR_REAL_KEY

5. Run app with local env file:

  flutter run --dart-define-from-file=.env.json
