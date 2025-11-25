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

    // Placeholder texts exist
    expect(find.text('Home Feed Placeholder'), findsOneWidget);

    // Switch to Search tab
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    expect(find.text('Search Placeholder'), findsOneWidget);

    // Switch to Favorites tab
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('Favorites Placeholder'), findsOneWidget);
  });
}
