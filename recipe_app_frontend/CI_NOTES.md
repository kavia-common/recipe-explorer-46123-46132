# CI Notes

- Analyzer excludes build/ and .dart_tool to prevent scanning large generated trees that can slow or crash the analysis server.
- When toggling dependencies, always run:
  - flutter clean
  - flutter pub get
- If re-enabling plugins (sqflite, shared_preferences), delete android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java so Flutter regenerates it.
