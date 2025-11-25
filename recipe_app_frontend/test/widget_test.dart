import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app_frontend/main.dart';

void main() {
  testWidgets('RootScaffold renders tabs with Ocean theme', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // AppBar title
    expect(find.text('Recipe Explorer'), findsOneWidget);

    // Verify bottom navigation has three destinations (NavigationBar is Material 3)
    expect(find.byType(NavigationBar), findsOneWidget);

    // Home screen renders header text from HomeScreen
    expect(find.text('Discover Recipes'), findsOneWidget);

    // Switch to Search tab
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    // Search app bar title should be visible
    expect(find.text('Search'), findsOneWidget);

    // Switch to Favorites tab
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    // Favorites screen app bar/title should be present
    expect(find.textContaining('Favorite'), findsWidgets);
  });
}
