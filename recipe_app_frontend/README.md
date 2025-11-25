# Recipe Explorer (Flutter)

## Overview
Recipe Explorer is a Flutter mobile app that lets users browse a curated set of mock recipes, search by name or tags, view detailed ingredients and steps, and save favorites for later. It applies the Ocean Professional theme (blue primary with amber accents) and uses a modern layout with a bottom navigation bar and smooth transitions.

The app is intentionally configured to build quickly in CI by minimizing heavy native plugins and pinning versions. It currently reads data from a local mock source with a repository abstraction to allow easy migration to a real API later.

## Features
### Browse
- Home tab shows a discovery header, tag chips aggregated from all recipes, and a responsive grid of recipe cards.
- Cards include image, tags, title, and meta (duration, servings, difficulty) with an optional Hero transition to details.

### Search
- Dedicated Search tab with an Ocean-styled search bar and debounced queries.
- Results reuse the same responsive grid view.
- Clear action resets search instantly.

### Detail
- Detailed recipe page with hero image, title, meta chips, ingredients list, and numbered steps.
- Integrated favorite toggle in the app bar.
- Friendly error states for missing/invalid navigation arguments.

### Favorites
- Favorites tab shows all saved recipes resolved from stored identifiers.
- Pull-to-refresh re-syncs favorites from storage and repository.
- Unfavorite inline via overlay action on each card.

## Architecture
This app follows a simple, clean layering with clear responsibilities:

- Models (lib/models)
  - recipe.dart: Recipe, Ingredient, RecipeStep, Difficulty enum. Immutable data structures with copyWith where appropriate.

- Data (lib/data)
  - mock_recipes.dart: In-memory mock dataset used during development and preview.
  - local/favorites_store.dart: Persistence helper using shared_preferences to store favorite recipe IDs.

- Repository (lib/repositories)
  - recipe_repository.dart: Abstracts data access; serves mock data now and simulates latency. Provides getAllRecipes, searchRecipes, getById, filterByTag.
  - repositories.dart: Barrel export to simplify imports.

- State (lib/state)
  - recipe_provider.dart: ChangeNotifier holding all and visible recipes, handling search and tag filtering while managing loading and error messages.
  - favorites_provider.dart: ChangeNotifier that loads/saves favorite IDs and exposes a toggle API.
  - state.dart: Barrel export for providers.

- Navigation (lib/navigation)
  - app_router.dart: Centralized route names and builders, plus onGenerateRoute for typed detail navigation via RecipeDetailArgs.

- Screens (lib/screens)
  - home/: HomeScreen and a responsive Sliver grid of cards, with pull-to-refresh and tag chips.
  - search/: SearchScreen featuring the OceanSearchBar and result grid.
  - favorites/: FavoritesScreen with loading, error, empty states and grid UI.
  - detail/: RecipeDetailScreen with hero header, meta chips, ingredients, and steps.

- Widgets (lib/widgets)
  - recipe_card.dart: Reusable card with hero support, overlay gradient, tags, and metadata row.
  - search_bar.dart: Debounced OceanSearchBar with integrated clear action.
  - section_header.dart: Generic section header (not required on every screen).

- Theme (lib/theme)
  - app_theme.dart: Ocean Professional Theme, plus helpers to produce subtle gradients.

- Entry (lib/main.dart)
  - Wires providers with MultiProvider, applies theme, sets routes via AppRouter, and renders RootScaffold with a Material 3 NavigationBar.

### State management (Provider)
- Provider library is used with ChangeNotifier to keep state simple and explicit.
- RecipeProvider owns the global recipe list, active search query, and active tag filter, exposing a “visible” list derived from the base dataset.
- FavoritesProvider owns the set of favorite IDs. It persists to shared_preferences via FavoritesStore and notifies consumers after updates.

### Data source
- Current source: mock_recipes.dart with a set of static Recipe objects and seeded image URLs for stable images.
- The repository simulates slight network latency so the UI shows realistic loading states.
- Favorites persistence uses shared_preferences (Android, iOS, Web implementations via Flutter plugins).

## Running locally and in this environment
- Local development
  1) Ensure Flutter SDK that matches the constraints in pubspec.yaml (environment.flutter).
  2) From the container root (recipe_app_frontend), run:
     - flutter pub get
     - flutter run
  3) To run tests:
     - flutter test

- In CI/preview environments
  - The project is tuned for faster initial builds. See Build-performance notes below for details and guidance when re-enabling heavier plugins.

## Build-performance notes
This project is configured to mitigate tight CI build timeouts by:
- Minimizing native plugins and pinning Gradle/AGP/Kotlin versions for stable, fast syncs.
- Optimizing gradle.properties for parallelism and caching.
- Keeping minSdk at 21 and jetifier disabled to reduce transforms.

For complete details, re-enablement steps, and troubleshooting, see BUILD_SPEED_NOTES.md.

## Adding a real API (future steps)
The app was designed with a repository abstraction and simple state providers to make API integration straightforward. A typical migration plan:

1) Create a remote data source
   - Add a file such as lib/data/remote/recipe_api.dart that uses http or dio to talk to your backend.
   - Define DTOs and mapping to the Recipe model. Keep model classes immutable.

2) Update the repository
   - Enhance RecipeRepository to accept a data source (mock or remote) via constructor.
   - Introduce an interface (abstract class) for the data source:
     - abstract class IRecipeDataSource { Future<List<Recipe>> getAll(); Future<Recipe?> getById(String id); Future<List<Recipe>> search(String q); Future<List<Recipe>> byTag(String tag); }
   - Provide a RemoteRecipeDataSource and a MockRecipeDataSource. Choose which one to inject from main.dart.

3) Wire dependency injection
   - In main.dart, pass the desired repository implementation to RecipeProvider(repository: ...).
   - For different flavors (dev vs prod), configure the repository binding accordingly.

4) Handle errors and loading
   - Ensure RecipeProvider and FavoritesProvider surface friendly error messages and loading flags (already implemented).
   - If the API supports pagination, extend the provider to manage pagination state and fetch more results on scroll.

5) Authentication and environment
   - If the API requires authentication or environment variables, re-enable flutter_dotenv or similar and add a secure configuration pattern. Make sure not to commit secrets.

6) Offline and caching (optional)
   - If needed, add a local cache layer (e.g., sqflite or hive) behind the repository interface to persist content and speed up cold starts.

Note: After adding new plugins (http, dio, hive, sqflite, etc.), re-check BUILD_SPEED_NOTES.md for adjustments (e.g., delete GeneratedPluginRegistrant.java so Flutter can regenerate registrations, run flutter clean, flutter pub get, etc.).

## Folder structure
- lib/
  - main.dart
  - models/
    - recipe.dart
  - data/
    - mock_recipes.dart
    - local/
      - favorites_store.dart
    - remote/ (future)
  - repositories/
    - recipe_repository.dart
    - repositories.dart
  - state/
    - recipe_provider.dart
    - favorites_provider.dart
    - state.dart
  - navigation/
    - app_router.dart
  - screens/
    - home/
      - home_screen.dart
      - widgets/
        - recipe_grid.dart
    - search/
      - search_screen.dart
    - favorites/
      - favorites_screen.dart
    - detail/
      - recipe_detail_screen.dart
      - widgets/
        - ingredient_tile.dart
        - step_tile.dart
  - widgets/
    - recipe_card.dart
    - search_bar.dart
    - section_header.dart
  - theme/
    - app_theme.dart
- test/
  - widget_test.dart
- android/ (Flutter Android wrapper)
- assets/ (empty placeholder, images loaded via network)

## How to extend safely
- Prefer adding new sources behind the repository interface to keep UI/state layers unchanged.
- Keep models immutable and serializers localized to the data layer.
- Maintain typed navigation via AppRouter and RecipeDetailArgs to avoid runtime argument errors.
- For UI polish and performance, reuse existing widgets (RecipeCard, RecipeGrid, OceanSearchBar) and gradients from AppTheme.

## Credits
- Flutter, Provider, and Shared Preferences plugins.
- Placeholder images from https://picsum.photos.

