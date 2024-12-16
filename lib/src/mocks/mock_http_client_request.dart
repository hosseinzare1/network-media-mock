import 'dart:io';

import 'package:mockito/mockito.dart';

/// A mock implementation of [HttpClientRequest], used internally by the package
/// to simulate HTTP client requests during widget and integration tests.
class MockHttpClientRequest extends Mock implements HttpClientRequest {
  final HttpClientResponse mockResponse;

  MockHttpClientRequest(this.mockResponse);

  @override
  Future<HttpClientResponse> close() async {
    return mockResponse;
  }

  @override
  Future<void> addStream(Stream<List<int>> stream) async {}
}
