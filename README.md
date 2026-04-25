# News App

A complete Flutter mobile news application built for an advanced Mobile Computing project.
The app consumes real-time headlines from NewsAPI and demonstrates clean structure,
API integration, async state management, responsive UI behavior, favorites management,
and dark mode support.

## 1. Project Overview

News App is designed to demonstrate practical mobile development concepts in one project.
It combines real-world networking, UI state handling, navigation, and responsive layout
techniques in a polished mobile experience.

### Main goals

1. Fetch live news data from a public REST API.
2. Display articles in a clean mobile-first interface.
3. Support navigation between a feed screen and a detail screen.
4. Handle loading, error, and empty states gracefully.
5. Allow users to search, filter, favorite articles, and switch between light/dark themes.
6. Keep sensitive API keys out of source control.

## 2. Feature List

### Core news features

1. Home screen with a live article feed.
2. Detail screen with full article presentation.
3. NewsAPI integration using `http`.
4. JSON parsing using `jsonDecode`.
5. Strongly typed model mapping with `Article.fromJson`.
6. Loading spinner while data is being fetched.
7. Error state with retry action.
8. Empty state when no articles are returned.

### Search and filtering features

1. Keyword search.
2. Category filtering.
3. Pull-to-refresh.
4. Dynamic feed updates based on search and category selections.

### Favorites and settings features

1. Favorites screen for saved articles.
2. Add/remove favorite articles from the home screen and detail screen.
3. Settings screen.
4. Dark mode toggle.
5. App-wide theme switching.

### UI and usability features

1. Modern Material 3 interface.
2. Responsive layout for mobile screens.
3. Adaptive spacing and typography for compact devices.
4. Multi-row category chips on mobile so all items remain visible.
5. Image fallback placeholders for broken or missing article images.

## 3. Tech Stack

1. Framework: Flutter
2. Language: Dart
3. Networking: `http`
4. API provider: NewsAPI (`https://newsapi.org`)
5. UI system: Material 3

## 4. Architecture

The project uses a clean, layered structure that keeps responsibilities separated.

### Folder structure

1. `lib/main.dart`
   App entry point, global theme state, and favorites state.
2. `lib/core/config/api_config.dart`
   API constants and secure key retrieval.
3. `lib/models/article.dart`
   Article entity and JSON parsing.
4. `lib/services/news_api_service.dart`
   Remote API communication and response handling.
5. `lib/screens/home_screen.dart`
   Home feed, search, category filter, favorite actions, settings access.
6. `lib/screens/news_details_screen.dart`
   Full article view and favorite toggle.
7. `lib/screens/favorites_screen.dart`
   Saved article list and removal actions.
8. `lib/screens/settings_screen.dart`
   Dark mode switch and app settings.

### Data flow

1. The app starts in `main.dart`.
2. `HomeScreen` triggers an async request to `NewsApiService`.
3. `NewsApiService` builds the request URL and calls NewsAPI.
4. The response JSON is decoded into `Article` objects.
5. `FutureBuilder` renders loading, error, empty, or success UI.
6. Tapping an article navigates to the details screen with `Navigator.push`.
7. Favorite state is managed at the app root and shared across screens.
8. Theme state is also managed at the app root and updated from Settings.

## 5. Screen-by-Screen Documentation

### 5.1 Home Screen

The home screen is the primary landing page.

#### What it does

1. Loads top headlines from NewsAPI.
2. Shows a search bar for keyword-based lookup.
3. Shows category chips for quick filtering.
4. Displays article cards in a `ListView.builder`.
5. Supports pull-to-refresh.
6. Lets users favorite articles directly from the feed.
7. Provides AppBar shortcuts to Favorites and Settings.

#### UI states

1. Loading state: centered `CircularProgressIndicator`.
2. Error state: message plus retry button.
3. Empty state: message when no articles are found.
4. Content state: article cards with image, title, and description.

### 5.2 News Details Screen

The details screen shows one selected article in a richer layout.

#### What it does

1. Displays a larger article image.
2. Shows the article title prominently.
3. Shows source and publish date metadata.
4. Presents the description and content sections.
5. Lets users favorite or unfavorite from the AppBar.

### 5.3 Favorites Screen

The favorites screen shows saved articles.

#### What it does

1. Lists all saved articles.
2. Shows article thumbnail, title, and source.
3. Allows removing favorites from the list.
4. Opens the details screen when an item is tapped.
5. Displays an empty state when no articles are saved.

### 5.4 Settings Screen

The settings screen handles app preferences.

#### What it does

1. Provides a dark mode switch.
2. Updates the app theme instantly.
3. Shows a small about section for the project.

## 6. API Integration Details

The app uses the NewsAPI `/v2/top-headlines` endpoint.

### Default request behavior

1. `country=us`
2. `pageSize=30`
3. `apiKey` is injected securely at runtime

### Conditional request behavior

1. Category is added only when a category other than `all` is selected.
2. Search query is sent using the `q` parameter.
3. When searching, the country parameter is removed to match NewsAPI behavior.

### Parsed article fields

1. `title`
2. `description`
3. `urlToImage`
4. `content`
5. `source.name`
6. `publishedAt`
7. `url`

## 7. Model Documentation

The `Article` model in `lib/models/article.dart` is responsible for mapping NewsAPI JSON into a typed Dart object.

### Why it matters

1. Keeps UI code simple.
2. Enforces a stable data structure.
3. Prevents repeated JSON handling across screens.
4. Adds safe default values when fields are missing.

### Default handling

1. Missing title becomes `Untitled article`.
2. Missing description becomes `No short description available.`
3. Missing content becomes `No detailed content available.`
4. Missing source becomes `Unknown Source`.
5. Invalid date becomes `null`.

## 8. State Management Overview

This app uses lightweight state management with `StatefulWidget` and callback-based sharing.

### Managed states

1. Current theme mode.
2. Favorites list.
3. Search text.
4. Selected category.
5. Current API request future.

### Why this approach was used

1. It is simple and appropriate for a college-level project.
2. It avoids unnecessary package overhead.
3. It keeps the example easy to understand and present.
4. It still demonstrates real shared app state.

## 9. Responsive Design Notes

The layout has been adjusted for small screens.

### Mobile behavior

1. Search bar uses compact padding and icon sizes on narrow devices.
2. Category chips wrap into multiple rows on mobile widths.
3. Card images and spacing shrink on compact screens.
4. Details screen image height scales based on available width.
5. Text sizes are reduced slightly for better readability on small screens.

### Result

The app remains usable on smaller phones without clipping or hidden controls.

## 10. Loading, Error, and Empty States

The app handles network states clearly.

### Loading

1. A spinner appears while the first request is pending.
2. RefreshIndicator provides visual feedback while pulling to refresh.

### Error

1. Errors from the API are shown as human-readable messages.
2. A retry button allows the user to attempt again.

### Empty

1. If no articles match the filter or search, the app shows an empty message.

## 11. Secure API Key Handling

This project is configured to avoid hardcoding secrets in source code.

### Recommended method

Run the app with:

```bash
flutter run --dart-define=NEWS_API_KEY=YOUR_REAL_KEY
```

### Local file method

Create a local file named `.env.json`:

```json
{
  "NEWS_API_KEY": "YOUR_REAL_KEY"
}
```

Then run:

```bash
flutter run --dart-define-from-file=.env.json
```

### Git safety

1. Never commit a real API key.
2. If a key was ever exposed, rotate it in the NewsAPI dashboard.
3. Keep secret values local to your machine only.

## 12. Setup and Run Guide

### Prerequisites

1. Flutter SDK installed.
2. Dart SDK (included with Flutter).
3. Android Studio or VS Code with Flutter tools.
4. Emulator or physical device.
5. Valid NewsAPI key.

### Installation steps

1. Open the project folder.
2. Install dependencies.

```bash
flutter pub get
```

3. Verify your available devices.

```bash
flutter devices
```

4. Run the app with your key.

```bash
flutter run --dart-define=NEWS_API_KEY=YOUR_REAL_KEY
```

## 13. Testing and Validation

The project has already been validated with:

1. `flutter analyze`
2. `flutter test`

### Current status

1. Static analysis passes.
2. Widget tests pass.

## 14. Error Handling Strategy

The app handles common failure conditions.

1. Missing API key is detected before the request is made.
2. Non-200 HTTP responses are converted into readable errors.
3. NewsAPI status errors are checked after decoding JSON.
4. Broken image links fall back to placeholders.
5. Empty responses show a clear empty state.
6. Retry actions let the user recover without restarting the app.

## 15. Limitations

1. NewsAPI free tier may have rate limits.
2. Some source content is truncated by the provider.
3. Full in-app article reading is not implemented yet.
4. Favorites are currently stored in memory for the running session only.
5. Dark mode selection is currently in memory for the running session only.

## 16. Future Improvements

1. Persist favorites using `shared_preferences` or local database.
2. Persist theme selection across app restarts.
3. Open full article links in an in-app browser.
4. Add offline caching.
5. Add pagination or infinite scroll.
6. Add stronger state management such as Provider, Riverpod, or Bloc.
7. Add unit and widget tests for favorites and settings.

## 17. College Project Mapping

This app covers the typical grading goals for an advanced mobile project.

1. Clean architecture style folder separation.
2. REST API integration.
3. JSON model parsing.
4. Multiple screens.
5. Navigator-based routing.
6. Search and filter functionality.
7. Loading, error, and empty states.
8. Responsive mobile UI.
9. Dark mode settings.
10. Favorites feature.
11. Secure secret handling.

## 18. Quick Command Reference

```bash
flutter pub get
flutter analyze
flutter test
flutter run --dart-define=NEWS_API_KEY=YOUR_REAL_KEY
flutter run --dart-define-from-file=.env.json
```

## 19. File Reference Summary

1. App root: `lib/main.dart`
2. API config: `lib/core/config/api_config.dart`
3. Model: `lib/models/article.dart`
4. API service: `lib/services/news_api_service.dart`
5. Home screen: `lib/screens/home_screen.dart`
6. Detail screen: `lib/screens/news_details_screen.dart`
7. Favorites screen: `lib/screens/favorites_screen.dart`
8. Settings screen: `lib/screens/settings_screen.dart`

## 20. Final Notes

This project is now a complete News App with:

1. Live headlines.
2. Search and category filters.
3. Favorites.
4. Dark mode.
5. Responsive mobile UI.
6. Clear documentation.
7. Safe API key handling.

It is suitable for submission as a college mobile computing project and can be extended further if needed.
