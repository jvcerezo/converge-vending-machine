import 'package:cvm/presentation/change_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// goal of this test is to check if the change screen is working properly
Future<void> pumpScreen(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: ChangeScreen()));
}

Future<void> enterAmounts(
  WidgetTester tester, {
  required String bill,
  required String owed,
}) async {
  // find text field bill and then add input for testing
  await tester.enterText(find.byType(TextFormField).first, bill);
  // find text field owed
  await tester.enterText(find.byType(TextFormField).last, owed);
  // render screen
  await tester.pump();
}

void main() {
  testWidgets('starts with the placeholder and a disabled button', (
    tester,
  ) async {
    await pumpScreen(tester);
    expect(find.text('Enter a bill and an amount owed.'), findsOneWidget);
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });

  // test case 4 from Romie's Docs
  testWidgets('renders teh breakdown for 100 / 27', (tester) async {
    await pumpScreen(tester);
    await enterAmounts(tester, bill: '100', owed: '27');
    await tester.tap(find.text('Compute change'));
    await tester.pumpAndSettle();

    expect(find.text('Change: P73'), findsOneWidget);
    expect(find.text('1 x P50 bill'), findsOneWidget);
    expect(find.text('1 x P20 bill'), findsOneWidget);
    expect(find.text('3 x P1 coin'), findsOneWidget);
  });

  testWidgets('shows the insufficient payment error for 500 / 600', (
    tester,
  ) async {
    await pumpScreen(tester);
    await enterAmounts(tester, bill: '500', owed: '600');
    await tester.tap(find.text('Compute change'));
    await tester.pumpAndSettle();

    expect(find.text('Insufficient payment.'), findsOneWidget);
  });

  testWidgets('shows no change due when the bill matches the price', (
    tester,
  ) async {
    await pumpScreen(tester);
    await enterAmounts(tester, bill: '500', owed: '500');
    await tester.tap(find.text('Compute change'));
    await tester.pumpAndSettle();

    expect(find.text('No change due.'), findsOneWidget);
  });

  testWidgets('rejects a bill that is not part of banknotes', (tester) async {
    await pumpScreen(tester);
    await enterAmounts(tester, bill: '300', owed: '100');
    await tester.pump();

    expect(
      find.text('Not a banknote. Try P20, P50, P100, P200, P500, or P1000'),
      findsOneWidget,
    );
  });

  testWidgets('reset clears the fields and the result', (tester) async {
    await pumpScreen(tester);
    await enterAmounts(tester, bill: '100', owed: '27');
    await tester.tap(find.text('Compute change'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();

    expect(find.text('Change: P73'), findsNothing);
    expect(find.text('Enter a bill and an amount owed.'), findsOneWidget);
  });
}
