import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:network_media_mock/network_media_mock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MockHttpOverrides(
    options: NetworkMediaMockOptions(
      isLogEnabled: true, // Enable logging
      responseDelay:
          const Duration(milliseconds: 500), // Simulate network latency
      urlToTypeMappers: [
        // Map URLs matching a regex to specific MIME types
        UrlToTypeMapping(
          RegExp(r'https://example.com/api/images/.*'),
          MockMimeType.imageSvgXml,
        ),
        UrlToTypeMapping(
          RegExp(r'https://picsum.photos/.*'),
          MockMimeType.imageJpeg,
        ),
        UrlToTypeMapping(
          RegExp(r'https://via.placeholder.com/600/.*'),
          MockMimeType.imagePng,
        ),
      ],
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WidgetsList(),
    );
  }
}

class WidgetsList extends StatelessWidget {
  const WidgetsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          spacing: 16,
          children: [
            Image.network(
              'https://picsum.photos/250?image=9',
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress?.cumulativeBytesLoaded ==
                    loadingProgress?.expectedTotalBytes) {
                  return child;
                }
                return const CircularProgressIndicator();
              },
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return const Text('Image.network error');
              },
            ),
            SvgPicture.network(
              'https://example.com/api/images/18813d1a',
              placeholderBuilder: (context) =>
                  const CircularProgressIndicator(),
            ),
            CachedNetworkImage(
              imageUrl: 'https://via.placeholder.com/600/771796',
              placeholder: (context, url) {
                return const CircularProgressIndicator();
              },
              errorWidget: (context, url, error) {
                return const Text('CachedNetworkImage Failed');
              },
            ),
          ],
        ),
      ),
    );
  }
}
