import 'dart:io';

import 'package:network_media_mock/src/logger.dart';
import 'package:network_media_mock/src/options.dart';
import 'package:network_media_mock/src/response_generator.dart';

import 'mock_http_client_request.dart';

/// A mock implementation of [HttpClient] that intercepts requests and serves
/// mock responses where applicable. If no mock response is available,
/// the request is forwarded to the main [HttpClient].
class MockHttpClient implements HttpClient {
  final HttpClient mainClient;
  final NetworkMediaMockOptions options;

  MockHttpClient(this.mainClient, this.options)
      : autoUncompress = mainClient.autoUncompress,
        idleTimeout = mainClient.idleTimeout,
        connectionTimeout = mainClient.connectionTimeout,
        maxConnectionsPerHost = mainClient.maxConnectionsPerHost,
        userAgent = mainClient.userAgent,
        _responseGenerator = ResponseGenerator(options: options);

  final ResponseGenerator _responseGenerator;

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async {
    var response = await _responseGenerator.generateResponse(url.toString());

    if (response != null) {

      NetworkMediaMockLogger.printSuccess("Media successfully mocked for: ${url.toString()}");
      await Future.delayed(options.responseDelay);

      var request = MockHttpClientRequest(response);

      return request;
    } else {

      return mainClient.openUrl(method, url);
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
  void addCredentials(Uri url, String realm, HttpClientCredentials credentials) {
    mainClient.addCredentials(url, realm, credentials);
  }

  @override
  void addProxyCredentials(String host, int port, String realm, HttpClientCredentials credentials) {
    mainClient.addProxyCredentials(host, port, realm, credentials);
  }

  @override
  set authenticate(Future<bool> Function(Uri url, String scheme, String? realm)? f) {
    mainClient.authenticate = f;
  }

  @override
  set authenticateProxy(Future<bool> Function(String host, int port, String scheme, String? realm)? f) {
    mainClient.idleTimeout = idleTimeout;
  }

  @override
  set badCertificateCallback(bool Function(X509Certificate cert, String host, int port)? callback) {
    mainClient.badCertificateCallback = callback;
  }

  @override
  void close({bool force = false}) {
    mainClient.close(force: force);
  }

  @override
  set connectionFactory(Future<ConnectionTask<Socket>> Function(Uri url, String? proxyHost, int? proxyPort)? f) {
    mainClient.connectionFactory = f;
  }

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) {
    return mainClient.delete(host, port, path);
  }

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) {
    return mainClient.deleteUrl(url);
  }

  @override
  set findProxy(String Function(Uri url)? f) {
    mainClient.findProxy = f;
  }

  @override
  Future<HttpClientRequest> get(String host, int port, String path) {
    return mainClient.get(host, port, path);
  }

  @override
  Future<HttpClientRequest> getUrl(Uri url) {
    return mainClient.getUrl(url);
  }

  @override
  Future<HttpClientRequest> head(String host, int port, String path) {
    return mainClient.head(host, port, path);
  }

  @override
  Future<HttpClientRequest> headUrl(Uri url) {
    return mainClient.headUrl(url);
  }

  @override
  set keyLog(Function(String line)? callback) {
    mainClient.keyLog = callback;
  }

  @override
  Future<HttpClientRequest> open(String method, String host, int port, String path) {
    return mainClient.open(method, host, port, path);
  }

  @override
  Future<HttpClientRequest> patch(String host, int port, String path) {
    return mainClient.patch(host, port, path);
  }

  @override
  Future<HttpClientRequest> patchUrl(Uri url) {
    return mainClient.patchUrl(url);
  }

  @override
  Future<HttpClientRequest> post(String host, int port, String path) {
    return mainClient.post(host, port, path);
  }

  @override
  Future<HttpClientRequest> postUrl(Uri url) {
    return mainClient.postUrl(url);
  }

  @override
  Future<HttpClientRequest> put(String host, int port, String path) {
    return mainClient.put(host, port, path);
  }

  @override
  Future<HttpClientRequest> putUrl(Uri url) {
    return mainClient.putUrl(url);
  }
}
