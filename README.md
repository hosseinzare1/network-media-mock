# **Network Media Mock**

**Network Media Mock** is a powerful Dart package for mocking HTTP requests for media files in Flutter applications. It enables seamless simulation of network media responses by intercepting HTTP requests and serving local asset files instead. This is ideal for **testing**, **prototyping**, or **demonstrating** applications without relying on live servers.


## **Supported Widgets**

This tool is designed to work seamlessly with the following widgets:

- `Image.network`
- `CachedNetworkImage`
- `SvgPicture.network`


## **Features**

- **Mock Media Responses**: Serve media files (e.g., images, PDFs, etc.) directly from local assets instead of fetching them from the internet.
- **Customizable Mappings**: Easily map URLs or MIME types to specific assets.
- **Regex URL Matching**: Use regex patterns to define and match URLs for mocking.
- **Type Recognition**: Automatically detect MIME types from file extensions or URL patterns.
- **Flexible Configuration**: Customize options such as response delays, logging, and default mappings.


## **Getting Started**

### **Installation**

To use **Network Media Mock**, follow these steps:

Add the package to your `pubspec.yaml` file:
```yaml
dependencies:
  network_media_mock: <latest-version>
```
Run the following command to install the package:

```bash
flutter pub get
```

## **Usage**

### **Using Default Options**

The simplest way to use Network Media Mock is by enabling it with the default options. This automatically maps common media types to the package’s pre-defined assets.

```dart
import 'package:network_media_mock/network_media_mock.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Initialize the package before any of test cases
    HttpOverrides.global = MockHttpOverrides(); // Use default options
  },
  );

  testWidgets(
    'Test Image.network with file extension',
            (WidgetTester tester) async {
      await tester.pumpWidget(
        Image.network(
          //In this case,The format of the file being returned will be determined from the extension.
          //(.jpg in this example)
          'https://anydomain.com/files/18813d1a.jpg',
        ),
      );

      // Your test logic goes here
    },
  );
}
```

### **Advanced Usage with Custom Options**

For more control, you can provide custom options such as URL-to-type mappings, MIME type-to-asset mappings, logging, and response delays.

```dart
import 'package:network_media_mock/network_media_mock.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Initialize the package before any of test cases
    HttpOverrides.global = MockHttpOverrides(
      options: NetworkMediaMockOptions(
        isLogEnabled: true, // Enable logging
        responseDelay: const Duration(seconds: 2), // Add a delay to simulate network latency
        urlToTypeMappers: [
          // Map URLs matching a regex to a specific MIME type
          UrlToTypeMapping(
            RegExp(r'https://example.com/api/files/.*'),
            MockMimeType.imageSvgXml,
          ),
          UrlToTypeMapping(
            RegExp(r'https://via.placeholder.com/600/.*'),
            MockMimeType.imagePng,
          ),
        ],
        typeToAssetMappers: [
          // Map MIME types to custom assets
          MimeTypeToAssetMapping(MockMimeType.imageJpeg, "assets/custom_image.jpg"),
          MimeTypeToAssetMapping(MockMimeType.applicationPdf, "assets/custom_doc.pdf"),
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
        ),
      );

      // Your test logic goes here
    },
  );

  testWidgets(
    'Test SvgPicture.network',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        SvgPicture.network(
          // This file type will be detected by the UrlToTypeMapping(*) defined in options.
          'https://example.com/api/files/18813d1a',
        ),
      );

      // Your test logic goes here
    },
  );

  testWidgets(
    'Test CachedNetworkImage',
            (WidgetTester tester) async {
      await tester.pumpWidget(
        CachedNetworkImage(
          imageUrl: 'https://via.placeholder.com/600/771796',
        ),
      );

      // Your test logic goes here
    },
  );
}
```

### **Declaring Custom Assets**
If you use custom assets, declare them in your app’s pubspec.yaml:
```yaml
flutter:
  assets:
    - assets/custom_image.jpg
    - assets/custom_doc.pdf
```

## **Configuration**

### **NetworkMediaMockOptions**

The `NetworkMediaMockOptions` class is the primary configuration tool for customizing the behavior of the mock system. Below are its key properties:

- **`isLogEnabled`**  
  Enables logging for debugging purposes. When set to `true`, logs are printed indicating whether a file was mocked or not.

- **`responseDelay`**  
  Simulates the network delay for loading media files. Specify the duration to wait before returning a mocked file.

- **`urlToTypeMappers`**  
  Maps specific URLs to file types. This is particularly useful when the file format cannot be determined from the URL itself.

- **`typeToAssetMappers`**  
  Maps file types (e.g., `image/png`, `video/mp4`) to custom mock files. If multiple files are provided for a type, one is selected randomly for each request. This configuration overrides the package's default small mock files.

## **Contributions**

Contributions are welcome! If you have suggestions for improvements, feature requests, or bug fixes, feel free to open an issue or submit a pull request on the [GitHub repository](https://github.com/hosseinzare1/network-media-mock).

## **License**

This package is distributed under the **BSD 3-Clause**. See the [LICENSE](https://github.com/hosseinzare1/network-media-mock/blob/main/LICENSE) file for more details.