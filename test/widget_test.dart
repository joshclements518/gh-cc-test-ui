import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/app.dart';
import 'package:harborline_navigator/services/services.dart';
import 'package:harborline_navigator/state/app_state.dart';

void main() {
  testWidgets('login continues into tab shell with sample content', (tester) async {
    final state = AppState(HarborlineServices());
    await tester.pumpWidget(HarborlineApp(state: state));
    await tester.pumpAndSettle();

    expect(find.textContaining('HARBORLINE'), findsWidgets);
    expect(find.text('Continue as guest'), findsOneWidget);

    await tester.tap(find.text('Continue as guest'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Plans'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Messages'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
    expect(find.textContaining('Aether'), findsWidgets);

    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Spotlight'), findsWidgets);

    await tester.tap(find.text('Messages'));
    await tester.pumpAndSettle();
    expect(find.text('INBOX'), findsOneWidget);
    expect(find.textContaining('Muster'), findsWidgets);

    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    expect(find.text('PROFILE'), findsOneWidget);
    expect(find.textContaining('Child permissions'), findsWidgets);
  });

  testWidgets('mock catalog surfaces appear after sign-in', (tester) async {
    final state = AppState(HarborlineServices());
    await state.signIn();
    await tester.pumpWidget(HarborlineApp(state: state));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Plans'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Day'), findsWidgets);
  });
}
