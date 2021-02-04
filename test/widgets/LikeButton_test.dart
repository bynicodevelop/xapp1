import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xapp/widgets/LikeButton.dart';

main() {
  testWidgets('Like Button with not data', (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(
      MaterialApp(
        title: 'Flutter Demo',
        home: LikeButton(),
      ),
    );

    // ACT
    // ASSERT
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Like Button with 123 likes', (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(
      MaterialApp(
        title: 'Flutter Demo',
        home: LikeButton(
          likes: 123,
        ),
      ),
    );

    // ACT
    // ASSERT
    expect(find.text('123'), findsOneWidget);
  });

  testWidgets('Like Button with 1234 likes', (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(
      MaterialApp(
        title: 'Flutter Demo',
        home: LikeButton(
          likes: 1234,
        ),
      ),
    );

    // ACT
    // ASSERT
    expect(find.text('1.23K'), findsOneWidget);
  });

  testWidgets('Like Button with 1233454 likes', (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(
      MaterialApp(
        title: 'Flutter Demo',
        home: LikeButton(
          likes: 1233454,
        ),
      ),
    );

    // ACT
    // ASSERT
    expect(find.text('1.23M'), findsOneWidget);
  });

  testWidgets('Like Button - User click on the button',
      (WidgetTester tester) async {
    bool clicked = false;
    int likes = 1;

    // ARRANGE
    await tester.pumpWidget(
      MaterialApp(
        home: LikeButton(
          likes: likes,
          onTap: () => clicked = true,
        ),
      ),
    );

    // ACT
    final Finder icon = find.byIcon(Icons.favorite_outline);
    await tester.tap(icon);
    await tester.pumpAndSettle();

    // ASSERT
    expect(clicked, true);
  });

  testWidgets('Like Button - Button like is liked',
      (WidgetTester tester) async {
    int likes = 1;

    // ARRANGE
    await tester.pumpWidget(
      MaterialApp(
        home: LikeButton(
          likes: likes,
          hasLiked: true,
          onTap: () => null,
        ),
      ),
    );

    // ACT
    final Finder icon = find.byIcon(Icons.favorite);

    // ASSERT
    expect(icon, findsOneWidget);
  });
}
