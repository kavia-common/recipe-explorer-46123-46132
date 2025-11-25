# Build Speed Notes

To mitigate CI build timeouts (~120s), this project is configured for fastest possible initial build:

- Dependencies minimized in pubspec.yaml (heavy native plugins like sqflite/shared_preferences disabled for now).
- Flutter SDK pinned in pubspec `environment.flutter` to avoid resolving very new SDKs that trigger long Gradle syncs.
- Android:
  - AGP pinned to 8.4.2 and Kotlin 1.8.22 for compatibility and faster sync.
  - minSdk set to 21 and jetifier disabled to reduce transform steps.
  - gradle.properties enables parallel builds and caching.

Re-enabling plugins:
- Uncomment dependencies in `pubspec.yaml`.
- Remove the minimal `GeneratedPluginRegistrant.java` override (delete the file so the Flutter tool regenerates it), then run:
  - flutter clean
  - flutter pub get
  - flutter build apk

If CI uses a different Flutter version, adjust `environment.flutter` bounds accordingly.
