import 'package:network_media_mock/src/mock_mime_type_enum.dart';

/// Represents a mapping between a MIME type and an asset path.
///
/// This class is used to define custom mappings for media files in tests,
/// allowing the `NetworkMediaMock` package to return specific assets for given
/// MIME types.
///
/// Example usage:
/// ```dart
/// final mapping = MimeTypeToAssetMapping(
///   MockMimeType.imageJpeg,
///   'assets/mock_image.jpg',
/// );
/// print(mapping.mimeType); // Output: MockMimeType.imageJpeg
/// print(mapping.assetPath); // Output: assets/mock_image.jpg
/// ```
class MimeTypeToAssetMapping {
  /// The MIME type being mapped.
  final MockMimeType mimeType;

  /// The path to the asset associated with this MIME type.
  final String assetPath;

  /// Creates a new `MimeTypeToAssetMapping` with the specified MIME type and asset path.
  MimeTypeToAssetMapping(this.mimeType, this.assetPath);
}
