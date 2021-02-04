import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xapp/widgets/AvatarBtn.dart';
import 'package:network_image_mock/network_image_mock.dart';

main() {
  testWidgets('When user click on the avatar button, we call ontap method.',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // ARRANGE
      bool clicked = false;

      await tester.pumpWidget(
        MaterialApp(
          title: 'Flutter Demo',
          home: AvatarBtn(
            photoURL: '',
            onTap: () => clicked = true,
          ),
        ),
      );

      // ACT
      final Finder raisedButton = find.byType(CircleAvatar);
      await tester.tap(raisedButton);

      // ASSERT
      expect(clicked, true);
    });
  });

  testWidgets('Should set image in avatar circle.',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // ARRANGE
      String photoURL = 'http://localhost/image.png';

      await tester.pumpWidget(
        MaterialApp(
          title: 'Flutter Demo',
          home: Scaffold(
            body: AvatarBtn(
              photoURL: photoURL,
              onTap: () => null,
            ),
          ),
        ),
      );

      // ACT
      final CircleAvatar imageNetworkFinder =
          tester.firstWidget(find.byType(CircleAvatar));
      final Finder hero = find.byType(Hero);

      // ASSERT
      expect(imageNetworkFinder.backgroundImage, NetworkImage(photoURL));
      expect(hero, findsNothing);
    });
  });

  testWidgets('Should set Hero animation.', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // ARRANGE
      String photoURL = 'http://localhost/image.png';

      await tester.pumpWidget(
        MaterialApp(
          title: 'Flutter Demo',
          home: Scaffold(
            body: AvatarBtn(
              tag: 'id',
              photoURL: photoURL,
              onTap: () => null,
            ),
          ),
        ),
      );

      // ACT
      final Finder hero = find.byType(Hero);

      // ASSERT
      expect(hero, findsOneWidget);
    });
  });
}
