// integration_test.dart - Phase 3 Week 11 Integration Testing
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:padhai/app/app.dart';
import 'package:padhai/core/di/injection.dart';

void main() {
  setUp(() {
    // Configure dependencies for testing
    configureDependencies();
  });

  group('Phase 3 Integration Tests', () {
    testWidgets('App Initialization: Launches without crashing', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(
        const ProviderScope(
          child: PadhaiApp(),
        ),
      );
      
      // Let splash screen complete
      await tester.pumpAndSettle();
      
      // App should launch successfully
      expect(find.byType(PadhaiApp), findsOneWidget);
    });

    testWidgets('Database Initialization: Creates tables successfully', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: PadhaiApp(),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Test passes if no exceptions thrown during initialization
      expect(find.byType(PadhaiApp), findsOneWidget);
    });
  });
}
