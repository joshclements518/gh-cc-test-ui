import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/features/polls/create_poll_screen.dart';
import 'package:harborline_navigator/services/services.dart';
import 'package:harborline_navigator/state/app_state.dart';

void main() {
  group('CreatePollScreen', () {
    testWidgets('displays form fields correctly', (tester) async {
      final state = AppState(HarborlineServices());

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            state: state,
            child: const CreatePollScreen(),
          ),
        ),
      );

      expect(find.text('Create Poll'), findsOneWidget);
      expect(find.text('POLL QUESTION'), findsOneWidget);
      expect(find.text('DEADLINE'), findsOneWidget);
      expect(find.text('Create Poll'), findsNWidgets(2)); // AppBar + Button
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('validates empty question', (tester) async {
      final state = AppState(HarborlineServices());

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            state: state,
            child: const CreatePollScreen(),
          ),
        ),
      );

      // Try to submit with empty question
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a question'), findsOneWidget);
    });

    testWidgets('shows deadline picker when deadline field is tapped',
        (tester) async {
      final state = AppState(HarborlineServices());

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            state: state,
            child: const CreatePollScreen(),
          ),
        ),
      );

      // Tap on deadline selector
      await tester.tap(find.text('Select deadline'));
      await tester.pumpAndSettle();

      // Date picker should appear
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('creates poll and displays poll id on success',
        (tester) async {
      final state = AppState(HarborlineServices());

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            state: state,
            child: const CreatePollScreen(),
          ),
        ),
      );

      // Enter question
      await tester.enterText(
        find.byType(TextFormField),
        'What snack should we get?',
      );

      // Select deadline
      await tester.tap(find.text('Select deadline'));
      await tester.pumpAndSettle();

      // Select a date (tap OK on date picker)
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Select a time (tap OK on time picker)
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Submit the form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
      await tester.pumpAndSettle();

      // Verify success message and poll ID are displayed
      expect(find.text('Poll Created Successfully'), findsOneWidget);
      expect(find.text('POLL ID'), findsOneWidget);
      expect(find.textContaining('poll_'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('Done button navigates back after successful creation',
        (tester) async {
      final state = AppState(HarborlineServices());
      bool popped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AppScope(
                          state: state,
                          child: const CreatePollScreen(),
                        ),
                      ),
                    );
                    popped = true;
                  },
                  child: const Text('Open Poll'),
                ),
              ),
            ),
          ),
        ),
      );

      // Open the create poll screen
      await tester.tap(find.text('Open Poll'));
      await tester.pumpAndSettle();

      // Fill and submit
      await tester.enterText(
        find.byType(TextFormField),
        'Test question',
      );
      await tester.tap(find.text('Select deadline'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
      await tester.pumpAndSettle();

      // Tap Done
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(popped, isTrue);
    });
  });
}
