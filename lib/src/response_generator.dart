import 'package:flutter/services.dart';
import 'package:network_media_mock/src/network_media_mock_logger.dart';
import 'package:network_media_mock/src/mock_mime_type_enum.dart';
import 'package:network_media_mock/src/mocks/mock_http_client_response.dart';
import 'package:network_media_mock/src/network_media_mock_options.dart';
import 'package:network_media_mock/src/mime_type_to_asset_mapping.dart';

/// Responsible for generating mock HTTP responses for media requests.
///
/// The `ResponseGenerator` is an internal utility used by the package to
/// simulate server responses for media requests. It determines the appropriate
/// MIME type and retrieves the corresponding asset file based on the provided
/// URL or custom mappings.
///
/// Returns `null` if no MIME type or asset is found.
///
/// ### Dependencies:
/// - `NetworkMediaMockOptions`: Provides configuration options for asset mappings.
/// - `NetworkMediaMockLogger`: Handles logging activities such as warnings or errors.
///
/// This class is not intended for direct use outside the package.
class ResponseGenerator {
  /// Configuration options for generating responses.
  final NetworkMediaMockOptions options;

  /// Logger instance for logging activities.
  final NetworkMediaMockLogger logger;

  /// Creates a `ResponseGenerator` with the specified options.
  ResponseGenerator({required this.options})
      : logger = NetworkMediaMockLogger(
          isLogEnabled: options.isLogEnabled,
        );

  /// Generates a mock HTTP response for the given URL.
  ///
  /// Attempts to:
  /// - Identify the MIME type of the requested resource.
  /// - Locate a corresponding asset file.
  /// - Return a `MockHttpClientResponse` containing the file data.
  ///
  /// If no type or asset is found, logs an error and returns `null`.
  Future<MockHttpClientResponse?> generateResponse(String url) async {
    MockMimeType? type = _getMimeTypeFromExtension(url.split('.').last);

    type ??= options.urlToTypeMappers.where((e) => e.urlRegEx.hasMatch(url)).firstOrNull?.mimeType;

    if (type != null) {
      List<String> assetPaths =
          options.typeToAssetMappers.where((e) => e.mimeType == type).map((e) => e.assetPath).toList();

      if (assetPaths.isEmpty) {
        assetPaths = _defaultTypeToAssetMappers.where((e) => e.mimeType == type).map((e) => e.assetPath).toList();
      }

      assetPaths.shuffle();

      var fileAssetPath = assetPaths.firstOrNull;

      if (fileAssetPath == null) {
        logger.printError("Url type recognized as '$type' but no asset found for url: $url");
        return null;
      }

      final fileBytes = (await rootBundle.load(fileAssetPath)).buffer.asUint8List();

      return MockHttpClientResponse(
        fileBytes: fileBytes,
        contentType: type.toString(),
      );
    }

    logger.printError("No type recognized for url: $url");
    return null;
  }

  /// Default mappings for common MIME types and their corresponding mock assets.
  List<MimeTypeToAssetMapping> get _defaultTypeToAssetMappers => [
        MimeTypeToAssetMapping(MockMimeType.applicationPdf, "assets/mock_pdf.pdf"),
        MimeTypeToAssetMapping(MockMimeType.imageJpeg, "assets/mock_jpg.jpg"),
        MimeTypeToAssetMapping(MockMimeType.imagePng, "assets/mock_png.png"),
        MimeTypeToAssetMapping(MockMimeType.imageSvgXml, "assets/mock_svg.svg"),
        MimeTypeToAssetMapping(MockMimeType.imageGif, "assets/mock_gif.gif"),
      ];

  /// Determines the MIME type based on the file extension.
  MockMimeType? _getMimeTypeFromExtension(String fileExtension) {
    return switch (fileExtension) {
      'pdf' => MockMimeType.applicationPdf,
      'jpg' || 'jpeg' => MockMimeType.imageJpeg,
      'png' => MockMimeType.imagePng,
      'svg' => MockMimeType.imageSvgXml,
      'webp' => MockMimeType.imageWebp,
      'gif' => MockMimeType.imageGif,
      _ => null,
    };
  }
}
