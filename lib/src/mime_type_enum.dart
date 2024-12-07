import 'package:collection/collection.dart';

/// Represents a MIME type with its `type` and `subType` components.
///
/// This enum provides predefined MIME types for common file types such as
/// images and application files, and includes utility methods for converting
/// strings into `MimeType` values.
///
/// Example usage:
/// ```dart
/// final mimeType = MimeType.imageJpeg;
/// print(mimeType.toString()); // Output: image/jpeg
///
/// final mimeTypeFromValue = MimeType.fromValueOrNull('image/png');
/// print(mimeTypeFromValue); // Output: MimeType.imagePng
/// ```
enum MimeType {
  applicationPdf('application', 'pdf'),
  imageJpeg('image', 'jpeg'),
  imageSvgXml('image', 'svg+xml'),
  imageWebp('webp', 'webp'),
  imageGif('image', 'gif'),
  imagePng('image', 'png');

  final String type;
  final String subType;

  const MimeType(this.type, this.subType);

  /// Parses a full MIME type string (e.g., `image/jpeg`) into a `MimeType` instance.
  ///
  /// Returns `null` if the input string does not match any predefined MIME types.
  ///
  /// Throws [ArgumentError] if the input is invalid.
  static MimeType? fromValueOrNull(String? content) {
    if (content?.split('/').length != 2 || content == null) {
      throw ArgumentError('Unknown MIME type: $content');
    }
    var type = content.split('/')[0];
    var subType = content.split('/')[1];
    return values.firstWhereOrNull((e) => e.type == type && e.subType == subType);
  }

  /// Finds a `MimeType` by its `subType` value.
  ///
  /// Returns `null` if no matching `MimeType` is found.
  static MimeType? fromSubtypeOrNull(String subType) {
    return values.firstWhereOrNull((e) => e.subType == subType);
  }

  /// Converts the MIME type to its string representation in the format `type/subType`.
  @override
  String toString() => '$type/$subType';
}
