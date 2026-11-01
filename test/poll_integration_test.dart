import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/app.dart';
import 'package:harborline_navigator/services/services.dart';
import 'package:harborline_navigator/state/app_state.dart';

void main() {
  testWidgets('complete poll creation flow from home screen', (tester) async {
    final state = AppState(HarborlineServices());
    await tester.pumpWidget(HarborlineApp(state: state));
    await tester.pumpAndSettle();

    // Sign in
    expect(find.text('Continue as guest'), findsOneWidget);
    await tester.tap(find.text('Continue as guest'));
    await tester.pumpAndSettle();

    // Verify we're on home screen
    expect(find.text('Home'), findsWidgets);

    // Find and tap the Create Poll action tile
    expect(find.text('Create Poll'), findsOneWidget);
    await tester.tap(find.text('Create Poll'));
    await tester.pumpAndSettle();

    // Verify we're on the create poll screen
    expect(find.text('POLL QUESTION'), findsOneWidget);
    expect(find.text('DEADLINE'), findsOneWidget);

    // Enter a poll question
    await tester.enterText(
      find.byType(TextFormField),
      'What snack should we get for Friday?',
    );
    await tester.pumpAndSettle();

    // Select a deadline
    await tester.tap(find.text('Select deadline'));
    await tester.pumpAndSettle();

    // Date picker appears - select OK
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Time picker appears - select OK
    expect(find.byType(TimePickerDialog), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Verify deadline was selected (should not show "Select deadline" anymore)
    expect(find.text('Select deadline'), findsNothing);

    // Submit the form
    final createButton = find.widgetWithText(ElevatedButton, 'Create Poll');
    expect(createButton, findsOneWidget);
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    // Verify poll was created successfully
    expect(find.text('Poll Created Successfully'), findsOneWidget);
    expect(find.text('POLL ID'), findsOneWidget);

    // Verify poll ID is displayed (should start with 'poll_')
    expect(find.textContaining('poll_'), findsOneWidget);

    // Verify the question and deadline are shown in the success message
    expect(
      find.textContaining('What snack should we get for Friday?'),
      findsOneWidget,
    );
    expect(find.textContaining('Deadline:'), findsOneWidget);

    // Verify the poll was actually created in the service
    final pollId = state.services.polls.getAllPolls().first.id;
    expect(pollId, startsWith('poll_'));
    expect(state.services.polls.getPoll(pollId), isNotNull);
    expect(
      state.services.polls.getPoll(pollId)!.question,
      equals('What snack should we get for Friday?'),
    );

    // Tap Done button to go back
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    // Verify we're back on home screen
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Create Poll'), findsOneWidget);
  });

  testWidgets('poll service maintains state across navigation', (tester) async {
    final state = AppState(HarborlineServices());
    await state.signIn();
    await tester.pumpWidget(HarborlineApp(state: state));
    await tester.pumpAndSettle();

    // Navigate to create poll
    await tester.tap(find.text('Create Poll'));
    await tester.pumpAndSettle();

    // Create first poll
    await tester.enterText(find.byType(TextFormField), 'First poll');
    await tester.tap(find.text('Select deadline'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
    await tester.pumpAndSettle();

    // Go back
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    // Create second poll
    await tester.tap(find.text('Create Poll'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Second poll');
    await tester.tap(find.text('Select deadline'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create Poll'));
    await tester.pumpAndSettle();

    // Verify both polls exist in the service
    final allPolls = state.services.polls.getAllPolls();
    expect(allPolls.length, equals(2));
    expect(allPolls.any((p) => p.question == 'First poll'), isTrue);
    expect(allPolls.any((p) => p.question == 'Second poll'), isTrue);
  });
}
