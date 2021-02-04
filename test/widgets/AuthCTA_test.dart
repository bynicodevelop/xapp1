import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xapp/widgets/AuthCTA.dart';

main() {
  testWidgets('When user click on the raised button, we call onpressed method.',
      (WidgetTester tester) async {
    // ARRANGE
    bool clicked = false;

    await tester.pumpWidget(
      MaterialApp(
        title: 'Flutter Demo',
        home: AuthCTA(
          onPressed: () => clicked = true,
        ),
      ),
    );

    // ACT
    final Finder raisedButton = find.byType(RaisedButton);
    await tester.tap(raisedButton);

    // ASSERT
    expect(clicked, true);
  });
}
