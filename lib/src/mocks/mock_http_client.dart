import 'dart:io';

import 'package:network_media_mock/src/network_media_mock_options.dart';
import 'package:network_media_mock/src/response_generator.dart';

import 'mock_http_client_request.dart';

/// A custom `HttpClient` implementation that simulates HTTP responses
/// based on predefined rules and mappings.
///
/// This class is internal to the package and not intended for public use. It extends
/// the base `HttpClient` and overrides specific methods to generate mocked responses
/// using the `ResponseGenerator`. If no mock matches the request, it delegates the call
/// to the main client.
///
/// ### Key Features:
/// - Routes requests to mocked responses using `ResponseGenerator`.
/// - Logs successes or failures when attempting to match mock data.
/// - Fallbacks to the original HTTP request if no mock is found.
///
/// ### Parameters:
/// - `_mainClient`: The original `HttpClient` instance to handle requests if no mock is found.
/// - `_options`: Configuration options defining mock behavior.
class MockHttpClient implements HttpClient {
  final HttpClient _mainClient;

  MockHttpClient(this._mainClient, NetworkMediaMockOptions _options)
      : autoUncompress = _mainClient.autoUncompress,
        idleTimeout = _mainClient.idleTimeout,
        connectionTimeout = _mainClient.connectionTimeout,
        maxConnectionsPerHost = _mainClient.maxConnectionsPerHost,
        userAgent = _mainClient.userAgent,
        _responseGenerator = ResponseGenerator(options: _options);

  final ResponseGenerator _responseGenerator;

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async {
    var response = await _responseGenerator.generateResponse(url.toString());

    if (response != null) {
      var request = MockHttpClientRequest(response);

      return request;
    } else {
      return _mainClient.openUrl(method, url);
    }
  }

  @override
  bool autoUncompress;

  @override
  Duration? connectionTimeout;

  @override
  Duration idleTimeout;

  @override
  int? maxConnectionsPerHost;

  @override
  String? userAgent;

  @override
  void addCredentials(
      Uri url, String realm, HttpClientCredentials credentials) {
    _mainClient.addCredentials(url, realm, credentials);
  }

  @override
  void addProxyCredentials(
      String host, int port, String realm, HttpClientCredentials credentials) {
    _mainClient.addProxyCredentials(host, port, realm, credentials);
  }

  @override
  set authenticate(
      Future<bool> Function(Uri url, String scheme, String? realm)? f) {
    _mainClient.authenticate = f;
  }

  @override
  set authenticateProxy(
      Future<bool> Function(
              String host, int port, String scheme, String? realm)?
          f) {
    _mainClient.idleTimeout = idleTimeout;
  }

  @override
  set badCertificateCallback(
      bool Function(X509Certificate cert, String host, int port)? callback) {
    _mainClient.badCertificateCallback = callback;
  }

  @override
  void close({bool force = false}) {
    _mainClient.close(force: force);
  }

  @override
  set connectionFactory(
      Future<ConnectionTask<Socket>> Function(
              Uri url, String? proxyHost, int? proxyPort)?
          f) {
    _mainClient.connectionFactory = f;
  }

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) {
    return _mainClient.delete(host, port, path);
  }

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) {
    return _mainClient.deleteUrl(url);
  }

  @override
  set findProxy(String Function(Uri url)? f) {
    _mainClient.findProxy = f;
  }

  @override
  Future<HttpClientRequest> get(String host, int port, String path) {
    return _mainClient.get(host, port, path);
  }

  @override
  Future<HttpClientRequest> getUrl(Uri url) {
    return _mainClient.getUrl(url);
  }

  @override
  Future<HttpClientRequest> head(String host, int port, String path) {
    return _mainClient.head(host, port, path);
  }

  @override
  Future<HttpClientRequest> headUrl(Uri url) {
    return _mainClient.headUrl(url);
  }

  @override
  set keyLog(Function(String line)? callback) {
    _mainClient.keyLog = callback;
  }

  @override
  Future<HttpClientRequest> open(
      String method, String host, int port, String path) {
    return _mainClient.open(method, host, port, path);
  }

  @override
  Future<HttpClientRequest> patch(String host, int port, String path) {
    return _mainClient.patch(host, port, path);
  }

  @override
  Future<HttpClientRequest> patchUrl(Uri url) {
    return _mainClient.patchUrl(url);
  }

  @override
  Future<HttpClientRequest> post(String host, int port, String path) {
    return _mainClient.post(host, port, path);
  }

  @override
  Future<HttpClientRequest> postUrl(Uri url) {
    return _mainClient.postUrl(url);
  }

  @override
  Future<HttpClientRequest> put(String host, int port, String path) {
    return _mainClient.put(host, port, path);
  }

  @override
  Future<HttpClientRequest> putUrl(Uri url) {
    return _mainClient.putUrl(url);
  }
}
