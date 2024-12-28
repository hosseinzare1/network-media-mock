[Example App](https://github.com/hosseinzare1/network-media-mock/tree/main/example)

### **Widget Test**

```dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_media_mock/network_media_mock.dart';

void main() {
  setUpAll(
        () {
      TestWidgetsFlutterBinding.ensureInitialized();

      // Initialize the package before any of test cases
      HttpOverrides.global = MockHttpOverrides(
        options: NetworkMediaMockOptions(
          isLogEnabled: true, // Enable logging
          responseDelay: const Duration(seconds: 2), // Simulate network latency
          urlToTypeMappers: [
            // Returns SVG file for any URL that match this RegExp
            UrlToTypeMapping(
              RegExp(r'https://example.com/api/files/.*'),
              MockMimeType.imageSvgXml,
            ),
          ],
        ),
      );
    },
  );

  testWidgets(
    'Test Image.network',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Image.network(
          //In this case,The format of the file being returned will be determined from the extension.
          //(.jpg in this example)
          'https://anydomain.com/files/18813d1a.jpg',
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
          // This file type will be detected by the UrlToTypeMapping(*) defined in options.
          'https://example.com/api/files/18813d1a',
          placeholderBuilder: (context) => const CircularProgressIndicator(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );
}

```

### **Integration Test**

Use the following commands to run integration tests:

```bash
flutter test integration_test/app_integration_test.dart
```

```dart
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
              RegExp(r'https://via.placeholder.com/600/.*'),
              MockMimeType.imagePng,
            ),
          ],
        ),
      );
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

```
