import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:xapp/widgets/ImageView.dart';

main() {
  testWidgets('Should display image', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // ARRANGE
      String imageURL = 'http://localhost/image.png';

      await tester.pumpWidget(
        MaterialApp(
          title: 'Flutter Demo',
          home: Scaffold(
            body: Container(
              child: ImageView(
                imageURL: imageURL,
              ),
            ),
          ),
        ),
      );

      // ACT
      final Image image = tester.firstWidget(find.byType(Image));

      // ASSERT
      expect(image.image, NetworkImage(imageURL));
    });
  });

  testWidgets('Should display image', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // ARRANGE
      bool clicked = false;

      await tester.pumpWidget(
        MaterialApp(
          title: 'Flutter Demo',
          home: Scaffold(
            body: Container(
              child: ImageView(
                onTapDown: (details) => clicked = true,
                imageURL: '',
              ),
            ),
          ),
        ),
      );

      // ACT
      final Finder finder = find.byType(Image);
      await tester.tap(finder);
      await tester.pump();

      final Finder hero = find.byType(Hero);

      // ASSERT
      expect(clicked, true);
      expect(hero, findsNothing);
    });
  });

  testWidgets('Should set hero animation', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          title: 'Flutter Demo',
          home: Scaffold(
            body: Container(
              child: ImageView(
                tag: 'tag',
                onTapDown: (details) => null,
                imageURL: '',
              ),
            ),
          ),
        ),
      );

      // ACT
      final Finder finder = find.byType(Hero);

      // ASSERT
      expect(finder, findsOneWidget);
    });
  });
}
