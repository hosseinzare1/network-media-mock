import 'package:collection/collection.dart';

/// Add more mime type whenever application supports new mimes.
enum MimeType {
  applicationPdf('application', 'pdf'),
  imageJpeg('image', 'jpeg'),
  imageJpg('image', 'jpg'),
  imageSvgXml('image', 'svg+xml'),
  imagePng('image', 'png');

  final String type;
  final String subType;

  const MimeType(this.type, this.subType);

  static MimeType? fromValueOrNull(String? content) {
    if (content?.split('/').length != 2 || content == null) {
      throw ArgumentError('Unknown MIME type: $content');
    }
    var type = content.split('/')[0];
    var subType = content.split('/')[1];

    return values.firstWhereOrNull((e) => e.type == type && e.subType == subType);
  }

  static MimeType? fromSubtypeOrNull(String subType) {
    return values.firstWhereOrNull((e) => e.subType == subType);
  }

  @override
  String toString() => '$type/$subType';
}
