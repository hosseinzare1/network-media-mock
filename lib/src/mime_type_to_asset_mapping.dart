import 'package:network_media_mock/src/mime_type_enum.dart';

class MimeTypeToAssetMapping {
  final MimeType mimeType;
  final String assetPath;

  MimeTypeToAssetMapping(
     this.mimeType,
     this.assetPath,
  );
}
