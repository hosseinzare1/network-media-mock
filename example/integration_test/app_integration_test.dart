import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:network_media_mock/network_media_mock.dart';

void main() {
  setUpAll(
    () {
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

      // Initialize the package before any of test cases
      HttpOverrides.global = MockHttpOverrides(
        options: NetworkMediaMockOptions(
          isLogEnabled: true, // Enable logging
          responseDelay:
              const Duration(milliseconds: 500), // Simulate network latency
          urlToTypeMappers: [
            // Map URLs matching a regex to specific MIME types
            UrlToTypeMapping(
              RegExp(r'https://example.com/api/images/.*'),
              MockMimeType.imageSvgXml,
            ),
            UrlToTypeMapping(
                RegExp(r'https://picsum.photos/.*'), MockMimeType.imageJpeg),
            UrlToTypeMapping(
              RegExp(r'https://via.placeholder.com/600/.*'),
              MockMimeType.imagePng,
            ),
          ],
        ),
      );
    },
  );

  testWidgets(
    'Test  Image.network',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        Image.network(
          'https://picsum.photos/250?image=9',
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress?.cumulativeBytesLoaded ==
                loadingProgress?.expectedTotalBytes) {
              return child;
            }
            return const CircularProgressIndicator();
          },
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
            return const Text('Image.network error');
          },
        ),
      );

      // Wait until the widget loads and the CircularProgressIndicator widget appears.
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);

      expect(find.text('Image.network error'), findsNothing);
    },
  );

  testWidgets(
    'Test SvgPicture.network',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        SvgPicture.network(
          'https://example.com/api/images/18813d1a',
          placeholderBuilder: (context) => const CircularProgressIndicator(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets(
    'Test CachedNetworkImage',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        CachedNetworkImage(
          imageUrl: 'https://via.placeholder.com/600/771796',
          placeholder: (context, url) {
            return const CircularProgressIndicator();
          },
          errorWidget: (context, url, error) {
            return const Text('CachedNetworkImage Failed');
          },
        ),
      );

      // Wait until the widget loads and the CircularProgressIndicator widget appears.
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);

      expect(find.text('CachedNetworkImage Failed'), findsNothing);
    },
  );
}
