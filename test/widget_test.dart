import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livestock_toxic_plant_detection/main.dart';

void main() {
  testWidgets('Home page smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify that the title is loaded
    expect(find.text('Toxic Plant Detector'), findsWidgets);
    expect(find.text('Common Toxic Plants'), findsOneWidget);
  });
}
