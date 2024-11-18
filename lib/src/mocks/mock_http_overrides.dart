import 'dart:io';

import 'package:network_media_mock/src/options.dart';

import 'mock_http_client.dart';

class MockHttpOverrides extends HttpOverrides {
  MockHttpOverrides({
    this.options = NetworkMediaMockOptions.defaultOptions,
  });

  final NetworkMediaMockOptions options;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    HttpClient mainClient = super.createHttpClient(context);
    return MockHttpClient(mainClient, options);
  }
}
