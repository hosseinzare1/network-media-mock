import 'dart:io';

import 'package:network_media_mock/src/network_media_mock_options.dart';

import 'mock_http_client.dart';

/// Overrides the default `HttpClient` implementation with `MockHttpClient`
/// to enable network media mocking during testing or development.
///
/// This class ensures all HTTP requests are routed through the `MockHttpClient`,
/// which uses predefined options and mappings to simulate network responses.
///
/// ### Parameters:
/// - `options`: An instance of `NetworkMediaMockOptions` to configure the mock behavior.
///              Defaults to `NetworkMediaMockOptions.defaultOptions`.
///
/// ### Usage:
/// Typically used to globally override HTTP requests during application runtime
/// by calling:
/// ```dart
/// HttpOverrides.global = MockHttpOverrides(options: customOptions);
/// ```
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
