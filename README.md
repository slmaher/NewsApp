# News App

Flutter News application using NewsAPI, clean project structure, multiple screens,
navigation, async data loading, and error handling.

## Run Locally (Safe for GitHub)

1. Install dependencies:

```bash
flutter pub get
```

2. Run with API key from command line (recommended):

```bash
flutter run --dart-define=NEWS_API_KEY=YOUR_REAL_KEY
```

This keeps the key out of source code.

## Optional: Use a local env JSON file

Create a local `.env.json` file (already ignored by `.gitignore`):

```json
{
	"NEWS_API_KEY": "YOUR_REAL_KEY"
}
```

Run with:

```bash
flutter run --dart-define-from-file=.env.json
```

## Important Security Note

If a key was committed previously, rotate/regenerate it on NewsAPI dashboard
before pushing this repository to GitHub.
