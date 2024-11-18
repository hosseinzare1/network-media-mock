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
    MimeType? type = _getMimeTypeFromExtension(url.split('.').last);

    // Try to recognize type with provided regexes if type is not recognized from url last part
    type ??= options.urlToTypeMappers.firstWhereOrNull((e) => e.urlRegEx.hasMatch(url))?.mimeType;

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

  List<MimeTypeToAssetMapping> get _defaultTypeToAssetMappers => [
        MimeTypeToAssetMapping(MimeType.applicationPdf, "assets/mock_pdf.pdf"),
        MimeTypeToAssetMapping(MimeType.imageJpeg, "assets/mock_jpg.jpg"),
        MimeTypeToAssetMapping(MimeType.imagePng, "assets/mock_png.png"),
        MimeTypeToAssetMapping(MimeType.imageSvgXml, "assets/mock_svg.svg"),
        MimeTypeToAssetMapping(MimeType.imageGif, "assets/mock_gif.gif"),
      ];

  MimeType? _getMimeTypeFromExtension(String fileExtension) {
    MimeType? mimeType = switch (fileExtension) {
      'pdf' => MimeType.applicationPdf,
      'jpg' || 'jpeg' => MimeType.imageJpeg,
      'png' => MimeType.imagePng,
      'svg' => MimeType.imageSvgXml,
      'webp' => MimeType.imageWebp,
      'gif' => MimeType.imageGif,
      _ => null,
    };
    return mimeType;
  }
}
