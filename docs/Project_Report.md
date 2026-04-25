# News App Project Report

## Abstract

News App is a Flutter-based mobile application that fetches live news headlines from NewsAPI and presents them in a clean, responsive, and user-friendly interface. The project was built as an advanced Mobile Computing assignment and demonstrates key mobile development concepts such as REST API integration, JSON parsing, asynchronous UI rendering, navigation between screens, responsive layouts, error handling, favorites management, and dark mode switching. The application is designed to be practical, easy to navigate, and suitable for a college-level demonstration of modern Flutter development practices.

## 1. Introduction

Mobile applications today are expected to be fast, responsive, visually appealing, and connected to real-time data sources. News App was created to meet these expectations by combining Flutter UI development with a live news service. Instead of using static sample data, the application connects to NewsAPI so users can browse current headlines and interact with the content in a meaningful way.

The project focuses on a real-world workflow:

1. Fetch articles from an external API.
2. Display them in a responsive mobile layout.
3. Allow navigation to a detail view.
4. Support search, categories, refresh, favorites, and theme switching.
5. Handle loading and error conditions gracefully.

## 2. Project Objectives

The main objectives of this project were:

1. Build a complete Flutter mobile application using clean project organization.
2. Integrate NewsAPI to retrieve top headlines dynamically.
3. Parse JSON data into strongly typed Dart model objects.
4. Use FutureBuilder to manage asynchronous loading states.
5. Provide multiple screens with Navigator.push navigation.
6. Design a clean and responsive UI suitable for mobile phones.
7. Add user-focused features such as search, category filtering, pull-to-refresh, favorites, and dark mode.
8. Keep API credentials out of source control.

## 3. Tools and Technologies

### 3.1 Framework and Language

1. Flutter
2. Dart

### 3.2 Packages and Services

1. http for REST requests.
2. NewsAPI for live headline data.
3. Material 3 for the app design system.

### 3.3 Development Tools

1. Visual Studio Code
2. Flutter CLI
3. Emulator or physical mobile device

## 4. Requirements Analysis

The application was designed to satisfy the following functional requirements:

1. Show a list of news articles on the home screen.
2. Fetch live headlines from an online API.
3. Open a separate details screen for each article.
4. Display loading indicators while data is being fetched.
5. Display clear error messages when a request fails.
6. Allow users to search articles by keyword.
7. Allow users to filter articles by category.
8. Allow pull-to-refresh.
9. Allow saving articles to favorites.
10. Allow switching between light and dark mode.
11. Adapt the UI for small mobile screens.

The project also includes quality-oriented non-functional requirements:

1. Simple but organized code structure.
2. Maintainable separation of concerns.
3. Responsive and readable mobile UI.
4. Safe handling of missing or invalid API data.
5. Secure management of API keys.

## 5. System Design

### 5.1 Architecture Overview

The application follows a clean layered structure:

1. Presentation layer: screens and widgets.
2. Data layer: API service and JSON parsing.
3. Model layer: Article class.
4. App state layer: theme mode and favorites stored at the root widget.

This separation improves maintainability and makes the project easier to explain and extend.

### 5.2 Data Flow

1. The app launches from main.dart.
2. HomeScreen requests articles from NewsApiService.
3. NewsApiService calls NewsAPI using the http package.
4. The response is decoded with jsonDecode.
5. JSON article objects are converted into Article instances.
6. FutureBuilder renders the result in the UI.
7. Selecting an article navigates to the details screen.
8. Users can save or remove favorites and switch theme modes.

## 6. Project Structure

The source code is organized as follows:

1. lib/main.dart
   App entry point, global theme mode, and favorites state.
2. lib/core/config/api_config.dart
   Base URL and secure API key retrieval.
3. lib/models/article.dart
   Article data model and JSON parsing.
4. lib/services/news_api_service.dart
   API request logic and error handling.
5. lib/screens/home_screen.dart
   Home page, search, filter, loading state, card list, favorite actions, and navigation.
6. lib/screens/news_details_screen.dart
   Detailed article view and favorite toggle.
7. lib/screens/favorites_screen.dart
   Saved articles list.
8. lib/screens/settings_screen.dart
   Dark mode switch and settings UI.

## 7. Implementation Details

### 7.1 Main App Entry

The main application widget initializes the MaterialApp, defines light and dark themes, and passes shared app state to the home screen. The root widget stores:

1. The current theme mode.
2. The list of favorite articles.
3. Methods for adding or removing favorites.
4. Methods for changing theme mode.

This allows theme and favorite changes to be reflected across the entire app.

### 7.2 Article Model

The Article model represents a single news item and includes the following fields:

1. title
2. description
3. urlToImage
4. content
5. source
6. publishedAt
7. url

The model also uses `fromJson` to convert raw API data into a Dart object. Missing or null fields are replaced with safe fallback values to prevent UI errors.

### 7.3 News API Service

The service layer handles communication with NewsAPI.

Responsibilities:

1. Build the top-headlines endpoint URL.
2. Add the API key.
3. Add optional category and search parameters.
4. Send the HTTP GET request.
5. Decode the JSON response.
6. Validate the API response status.
7. Convert the returned article list into `Article` objects.

### 7.4 Home Screen

The home screen provides the main news browsing experience.

Features:

1. Search field for keyword lookup.
2. Category chips for filtering headlines.
3. Loading spinner while data is fetched.
4. Error panel with retry button.
5. Empty state when nothing matches.
6. News cards rendered with ListView.builder.
7. Favorite button on each card.
8. Navigation buttons to Favorites and Settings.

### 7.5 Details Screen

The details screen shows the selected article in more depth.

It includes:

1. Large article image.
2. Title.
3. Source and date chips.
4. Description.
5. Content text.
6. Favorite toggle in the AppBar.

### 7.6 Favorites Screen

The favorites screen allows users to review saved articles.

It includes:

1. A list of saved articles.
2. Image thumbnails.
3. Source text.
4. Remove favorite action.
5. Empty state message when no items are saved.

### 7.7 Settings Screen

The settings screen provides the dark mode toggle.

It includes:

1. A switch to enable or disable dark theme.
2. Immediate theme updates.
3. A simple about section.

## 8. API Integration

The application uses the NewsAPI top-headlines endpoint.

### 8.1 Endpoint

1. `https://newsapi.org/v2/top-headlines`

### 8.2 Request Parameters

1. `country=us`
2. `pageSize=30`
3. `apiKey=...`
4. `category=...` when a category is selected
5. `q=...` when a search query is entered

### 8.3 Parsed Response Fields

1. title
2. description
3. urlToImage
4. content
5. source.name
6. publishedAt
7. url

## 9. User Interface Design

### 9.1 Design Style

The UI uses a modern Material 3 style with:

1. Clean card layouts.
2. Rounded corners.
3. Light spacing and clear typography.
4. Adaptive behavior for mobile widths.
5. Dark mode support.

### 9.2 Responsive Behavior

The app adapts to smaller mobile screens by:

1. Reducing padding on compact devices.
2. Using smaller font sizes where needed.
3. Scaling image sizes.
4. Wrapping category chips into multiple rows.
5. Preserving readability and touch usability.

## 10. Loading, Empty, and Error Handling

### 10.1 Loading State

A CircularProgressIndicator is shown while the articles are being fetched.

### 10.2 Empty State

If no articles are returned for a given search or filter, the app displays a friendly empty message.

### 10.3 Error State

If the request fails, the app displays an error message and a retry button so the user can try again.

### 10.4 Image Fallbacks

If an article image fails to load, the app shows a placeholder instead of breaking the layout.

## 11. Security and API Key Handling

The project avoids hardcoding the API key in source code.

Recommended run command:

```bash
flutter run --dart-define=NEWS_API_KEY=YOUR_REAL_KEY
```

Optional local file method:

```json
{
  "NEWS_API_KEY": "YOUR_REAL_KEY"
}
```

Then run:

```bash
flutter run --dart-define-from-file=.env.json
```

Security notes:

1. Never commit a real API key.
2. If a key was ever exposed, regenerate it in NewsAPI.
3. Keep local secret files out of GitHub.

## 12. Testing and Validation

The project was checked using:

1. `flutter analyze`
2. `flutter test`

Validation results during development:

1. Analyzer completed successfully.
2. Widget tests completed successfully.

## 13. Limitations

1. The free NewsAPI plan may enforce request limits.
2. Some article content is truncated by the source provider.
3. Favorites and dark mode are currently kept in memory for the session only.
4. Full article viewing in an embedded browser is not yet added.

## 14. Future Enhancements

1. Persist favorites using shared_preferences or a local database.
2. Persist the dark mode preference across restarts.
3. Add pagination or infinite scroll.
4. Open full article links in an in-app browser.
5. Add offline caching.
6. Strengthen state management with Provider, Riverpod, or Bloc.
7. Add more tests for screen behavior and state changes.

## 15. Conclusion

News App is a complete Flutter mobile project that demonstrates practical mobile development skills using a real news API, a responsive user interface, multi-screen navigation, shared application state, and secure configuration practices. The project is suitable for academic submission and can be expanded further with persistence, offline caching, and stronger state management in future iterations.

## Appendix A. Quick Run Commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run --dart-define=NEWS_API_KEY=YOUR_REAL_KEY
flutter run --dart-define-from-file=.env.json
```
