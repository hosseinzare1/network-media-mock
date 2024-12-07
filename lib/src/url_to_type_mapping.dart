import 'package:network_media_mock/src/mime_type_enum.dart';

/// Represents a mapping between a URL pattern and a MIME type.
///
/// This class allows specifying how to recognize MIME types for URLs that may
/// not include file extensions.
///
/// Example usage:
/// ```dart
/// final mapping = UrlToTypeMapping(
///   RegExp(r'https://example.com/api/images/.*'),
///   MockMimeType.imagePng,
/// );
/// print(mapping.urlRegEx); // Output: RegExp(r'https://example.com/api/images/.*')
/// print(mapping.mimeType); // Output: MockMimeType.imagePng
/// ```
class UrlToTypeMapping {
  /// A regular expression to match URLs.
  final RegExp urlRegEx;

  /// The MIME type to associate with URLs matching the regex.
  final MockMimeType mimeType;

  /// Creates a new `UrlToTypeMapping` with the specified regex and MIME type.
  UrlToTypeMapping(this.urlRegEx, this.mimeType);
}
