import 'package:network_media_mock/src/mime_type_to_asset_mapping.dart';
import 'package:network_media_mock/src/url_to_type_mapping.dart';

class NetworkMediaMockOptions {
  /// Whether to return logs or not
  final bool isLogEnabled;

  /// Specify custom files to be returner for mime types
  final List<MimeTypeToAssetMapping> typeToAssetMappers;

  /// Specify custom files to be returner for mime types
  final List<UrlToTypeMapping> urlToTypeMappers;

  /// delay duration before returning response
  final Duration responseDelay;

  static const NetworkMediaMockOptions defaultOptions = NetworkMediaMockOptions();

  const NetworkMediaMockOptions({
    this.isLogEnabled = true,
    this.typeToAssetMappers = const [],
    this.urlToTypeMappers = const [],
    this.responseDelay = const Duration(milliseconds: 100),
  });
}
