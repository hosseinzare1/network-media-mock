import 'package:network_media_mock/src/mime_type_enum.dart';

class UrlToTypeMapping {
  final RegExp urlRegEx;
  final MimeType mimeType;

  UrlToTypeMapping(
     this.urlRegEx,
     this.mimeType,
  );
}
