import 'dart:io';

import 'package:mockito/mockito.dart';

class MockHttpClientRequest extends Mock implements HttpClientRequest {
  final HttpClientResponse mockResponse;

  MockHttpClientRequest(this.mockResponse);

  @override
  Future<HttpClientResponse> close() async {
    return mockResponse;
  }

  @override
  Future<void> addStream(Stream<List<int>> stream) async {

  }
}
