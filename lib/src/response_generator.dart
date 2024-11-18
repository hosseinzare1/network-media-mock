import 'package:flutter/services.dart';
import 'package:network_media_mock/src/network_media_mock_logger.dart';
import 'package:network_media_mock/src/mime_type_enum.dart';
import 'package:network_media_mock/src/mocks/mock_http_client_response.dart';
import 'package:network_media_mock/src/options.dart';
import 'package:network_media_mock/src/mime_type_to_asset_mapping.dart';
import 'package:collection/collection.dart';

class ResponseGenerator {
  final NetworkMediaMockOptions options;
  final NetworkMediaMockLogger logger;

  ResponseGenerator({required this.options})
      : logger = NetworkMediaMockLogger(
          isLogEnabled: options.isLogEnabled,
        );

  Future<MockHttpClientResponse?> generateResponse(String url) async {
    // Try to recognize type from url last part
    MimeType? type = MimeType.fromValueOrNull(url.split('.').last);

    // Try to recognize type with provided regexes if type is not recognized from url last part
    if (type != null) {
      type = options.urlToTypeMappers.firstWhereOrNull((e) => e.urlRegEx.hasMatch(url))?.mimeType;
    }

    if (type != null) {
      List<String> assetPaths = [];

      // Try to find asset for type from custom mappers
      assetPaths = options.typeToAssetMappers.where((e) => e.mimeType == type).map((e) => e.assetPath).toList();

      // If no asset found for type, try to find asset for type from default mappers
      if (assetPaths.isEmpty) {
        assetPaths = _defaultTypeToAssetMappers.where((e) => e.mimeType == type).map((e) => e.assetPath).toList();
      }

      // If multiple paths are found for a type, shuffle and take first
      assetPaths.shuffle();

      var fileAssetPath = assetPaths.firstOrNull;

      if (fileAssetPath == null) {
        logger.printError("Url type recognized as '$type' but no asset found for url: $url");
        return null;
      }

      final fileBytes = (await rootBundle.load(fileAssetPath)).buffer.asUint8List();

      var response = MockHttpClientResponse(
        fileBytes: fileBytes,
        contentType: type.toString(),
      );

      return response;
    }

    logger.printError("No type recognized for url: $url");

    return null;
  }

  static List<MimeTypeToAssetMapping> get _defaultTypeToAssetMappers => [
        MimeTypeToAssetMapping(MimeType.applicationPdf, ""),
        MimeTypeToAssetMapping(MimeType.imageJpeg, ""),
        MimeTypeToAssetMapping(MimeType.imageJpg, ""),
        MimeTypeToAssetMapping(MimeType.imagePng, ""),
        MimeTypeToAssetMapping(MimeType.imageSvgXml, ""),
      ];
}
