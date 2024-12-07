import 'package:network_media_mock/src/mime_type_to_asset_mapping.dart';
import 'package:network_media_mock/src/url_to_type_mapping.dart';

/// A configuration class for customizing the behavior of the
/// `NetworkMediaMock` package.
///
/// This class allows you to define options like enabling/disabling logs,
/// setting a delay before responses are returned, and specifying custom file
/// mappings for MIME types and URLs.
///
/// You can pass an instance of this class to the `NetworkMediaMock` to
/// configure how media data is returned based on your needs.
///
/// Example usage:
/// ```dart
/// final options = NetworkMediaMockOptions(
///   isLogEnabled: false,
///   responseDelay: Duration(seconds: 2),
///   typeToAssetMappers: [MimeTypeToAssetMapping(...), MimeTypeToAssetMapping(...)],
///   urlToTypeMappers: [UrlToTypeMapping(...), UrlToTypeMapping(...)],
/// );
/// ```
class NetworkMediaMockOptions {
  /// Whether to return logs or not.
  ///
  /// When set to `true`, logs related to the network media mock will be
  /// printed to the console. Default is `true`.
  final bool isLogEnabled;

  /// Delay duration before returning a response.
  ///
  /// This defines the amount of time that will be waited before returning
  /// a response, simulating network latency or server delay. The default
  /// value is 100 milliseconds.
  final Duration responseDelay;

  /// Specify custom file mappings for MIME types.
  ///
  /// A list of [MimeTypeToAssetMapping] objects that define which media files
  /// should be returned for specific MIME types. You can specify multiple asset
  /// files for a single MIME type, and when the mock client returns a media file
  /// for that MIME type, it will randomly select one of the specified assets.
  ///
  /// If no asset is defined for a particular MIME type, the mock client will return
  /// a default media file for that MIME type. By default, this list is empty.
  ///
  /// Example:
  /// ```dart
  /// final options = NetworkMediaMockOptions(
  ///   typeToAssetMappers: [
  ///     MimeTypeToAssetMapping(mimeType: MimeType.imageJpeg, assetPath: 'assets/image1.jpg'),
  ///     MimeTypeToAssetMapping(mimeType: MimeType.imageJpeg, assetPath: 'assets/image2.jpg'),
  ///     MimeTypeToAssetMapping(mimeType: MimeType.imagePng, assetPath: 'assets/image3.png'),
  ///   ],
  /// );
  /// ```
  /// In this example:
  /// - For `image/jpeg`, either `image1.jpg` or `image2.jpg` will be randomly selected when serving a response.
  /// - For `image/png`, only `image3.png` will be returned (since there’s only one asset defined).
  final List<MimeTypeToAssetMapping> typeToAssetMappers;

  /// Specify custom file mappings for URLs.
  ///
  /// A list of [UrlToTypeMapping] objects that define how to map certain
  /// URLs to their corresponding MIME types. This list is particularly useful
  /// for recognizing URLs that do not have file extensions (e.g., `https://example.com/api/media`).
  /// By default, this list is empty.
  ///
  /// Example:
  /// ```dart
  /// final options = NetworkMediaMockOptions(
  ///   urlToTypeMappers: [
  ///     UrlToTypeMapping(urlRegEx: RegExp(r'https://example.com/api/media.*'), mimeType: MimeType.imageJpeg),
  ///     UrlToTypeMapping(urlRegEx: RegExp(r'https://example.com/api/audio.*'), mimeType: MimeType.audioMp3),
  ///   ],
  /// );
  /// ```
  /// In this example:
  /// - Any URL matching the pattern `https://example.com/api/media.*` (with no file extension) will return the media with MIME type `image/jpeg`
  /// - Any URL matching the pattern `https://example.com/api/audio.*` (with no file extension) will return the media with MIME type `audio/mp3`
  final List<UrlToTypeMapping> urlToTypeMappers;

  /// A default instance of [NetworkMediaMockOptions] with predefined values.
  ///
  /// This default configuration has `isLogEnabled` set to `true`, a `responseDelay`
  /// of 100 milliseconds, and empty lists for both `typeToAssetMappers` and
  /// `urlToTypeMappers`.
  static const NetworkMediaMockOptions defaultOptions = NetworkMediaMockOptions();

  /// Creates an instance of [NetworkMediaMockOptions] with custom configurations.
  ///
  /// The following options are configurable:
  /// - `isLogEnabled`: Enables or disables logging. Default is `true`.
  /// - `responseDelay`: The delay before a response is returned. Default is `100ms`.
  /// - `typeToAssetMappers`: A list of [MimeTypeToAssetMapping] objects for mapping MIME types to assets.
  /// - `urlToTypeMappers`: A list of [UrlToTypeMapping] objects for mapping URLs to MIME types.
  ///
  /// Example:
  /// ```dart
  /// final options = NetworkMediaMockOptions(
  ///   isLogEnabled: false,
  ///   responseDelay: Duration(seconds: 2),
  ///   typeToAssetMappers: [...],
  ///   urlToTypeMappers: [...],
  /// );
  /// ```
  const NetworkMediaMockOptions({
    this.isLogEnabled = true,
    this.responseDelay = const Duration(milliseconds: 100),
    this.typeToAssetMappers = const [],
    this.urlToTypeMappers = const [],
  });
}