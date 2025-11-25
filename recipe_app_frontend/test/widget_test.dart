import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app_frontend/main.dart';

void main() {
  testWidgets('Minimal home renders with Ocean theme and progress', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Recipe app is ready'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('recipe_app_frontend'), findsOneWidget);
  });
}
