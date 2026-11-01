import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/app.dart';
import 'package:harborline_navigator/features/explore/explore_screen.dart';
import 'package:harborline_navigator/features/hybrid/hybrid_flows.dart';
import 'package:harborline_navigator/features/messages/messages_screen.dart';
import 'package:harborline_navigator/features/plans/plans_screen.dart';
import 'package:harborline_navigator/services/services.dart';
import 'package:harborline_navigator/state/app_state.dart';

Future<AppState> signedIn() async {
  final state = AppState(HarborlineServices());
  await state.signIn();
  return state;
}

Future<void> frame(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(child);
  await tester.pumpAndSettle(const Duration(milliseconds: 500));
}

void main() {
  testWidgets('01 login', (tester) async {
    final state = AppState(HarborlineServices());
    await frame(tester, HarborlineApp(state: state));
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('../test/evidence/01-login.png'));
  });

  testWidgets('02 home onboard', (tester) async {
    final state = await signedIn();
    await frame(tester, HarborlineApp(state: state));
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('../test/evidence/02-home-onboard.png'));
  });

  testWidgets('03 home athome', (tester) async {
    final state = await signedIn();
    state.setMode(VoyageMode.atHome);
    await frame(tester, HarborlineApp(state: state));
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('../test/evidence/03-home-athome.png'));
  });

  testWidgets('04 plans', (tester) async {
    final state = await signedIn();
    await frame(tester, HarborlineApp(state: state));
    await tester.tap(find.text('Plans'));
    await tester.pumpAndSettle();
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('../test/evidence/04-plans.png'));
  });

  testWidgets('05 activity', (tester) async {
    final state = await signedIn();
    await frame(
      tester,
      MaterialApp(home: AppScope(state: state, child: const ActivityDetailScreen(eventId: 'e5'))),
    );
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('../test/evidence/05-activity-detail.png'));
  });

  testWidgets('06 explore', (tester) async {
    final state = await signedIn();
    await frame(tester, HarborlineApp(state: state));
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('../test/evidence/06-explore.png'));
  });

  testWidgets('07 venue', (tester) async {
    final state = await signedIn();
    await frame(
      tester,
      MaterialApp(home: AppScope(state: state, child: const VenueDetailScreen(venueId: 'v1'))),
    );
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('../test/evidence/07-venue-detail.png'));
  });

  testWidgets('08 messages', (tester) async {
    final state = await signedIn();
    await frame(tester, HarborlineApp(state: state));
    await tester.tap(find.text('Messages'));
    await tester.pumpAndSettle();
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('../test/evidence/08-messages-inbox.png'));
  });

  testWidgets('09 chat', (tester) async {
    final state = await signedIn();
    await frame(
      tester,
      MaterialApp(home: AppScope(state: state, child: const ChatThreadScreen(threadId: 'c1'))),
    );
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('../test/evidence/09-chat.png'));
  });

  testWidgets('10 account', (tester) async {
    final state = await signedIn();
    await frame(tester, HarborlineApp(state: state));
    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('../test/evidence/10-account.png'));
  });

  testWidgets('11 hybrid', (tester) async {
    final state = await signedIn();
    await frame(
      tester,
      MaterialApp(
        home: AppScope(
          state: state,
          child: const HybridFlowScreen(flowId: 'gratuities', title: 'Gratuities'),
        ),
      ),
    );
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('../test/evidence/11-hybrid-gratuities.png'));
  });
}
