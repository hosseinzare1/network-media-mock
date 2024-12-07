/// Represents a MIME type with its `type` and `subType` components.
///
/// This enum provides predefined MIME types for common file types such as
/// images and application files, and includes utility methods for converting
/// strings into `MockMimeType` values.
///
/// Example usage:
/// ```dart
/// final mimeType = MockMimeType.imageJpeg;
/// print(mimeType.toString()); // Output: image/jpeg
/// ```
enum MockMimeType {
  applicationPdf('application', 'pdf'),
  imageJpeg('image', 'jpeg'),
  imageSvgXml('image', 'svg+xml'),
  imageWebp('webp', 'webp'),
  imageGif('image', 'gif'),
  imagePng('image', 'png');

  final String type;
  final String subType;

  const MockMimeType(this.type, this.subType);

  /// Converts the MIME type to its string representation in the format `type/subType`.
  @override
  String toString() => '$type/$subType';
}
