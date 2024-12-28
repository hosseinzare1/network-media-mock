import 'dart:async';
import 'dart:io';
import 'package:mockito/mockito.dart';

/// A mock implementation of [HttpClientResponse], used internally by the package
/// to simulate HTTP responses with predefined content and headers.
class MockHttpClientResponse extends Mock implements HttpClientResponse {
  /// The raw bytes of the response content.
  final List<int> fileBytes;

  /// The MIME type of the response content.
  final String contentType;

  /// The simulated delay for delivering the response.
  ///
  /// This delay is distributed across chunks when streaming the response body.
  final Duration responseDelay;

  /// The size of each chunk of data delivered during the response streaming.
  final int chunkSize = 256;

  /// Creates an instance of [MockHttpClientResponse] with the specified content.
  ///
  /// [fileBytes]: The raw content bytes to include in the response.
  /// [contentType]: The MIME type of the response content.
  /// [responseDelay]: The simulated delay for delivering the response.
  MockHttpClientResponse({
    required this.fileBytes,
    required this.contentType,
    required this.responseDelay,
  });

  /// Always returns [HttpStatus.ok] (200) to indicate a successful response.
  @override
  int get statusCode => HttpStatus.ok;

  /// Returns mock HTTP headers containing the `Content-Type` of the response.
  @override
  HttpHeaders get headers {
    final ContentType responseContentType = ContentType.parse(contentType);
    return MockHttpHeaders(responseContentType: responseContentType);
  }

  /// Throws an error as socket detachment is not implemented in this mock.
  @override
  Future<Socket> detachSocket() {
    throw UnimplementedError("detachSocket is not implemented in the mock.");
  }

  /// Allows listening to the [fileBytes] as a response stream.
  ///
  /// Simulates receiving the response body as a stream of bytes.
  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int>)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    final controller = StreamController<List<int>>();

    final chunkCount = (fileBytes.length / chunkSize).ceil();
    final chunkDelayMilliseconds =
        ((responseDelay.inMilliseconds) / chunkCount).ceil();
    final chunkDelay = Duration(milliseconds: chunkDelayMilliseconds);

    Future(() async {
      for (int i = 0; i < fileBytes.length; i += chunkSize) {
        final chunk = fileBytes.sublist(
            i,
            i + chunkSize > fileBytes.length
                ? fileBytes.length
                : i + chunkSize);
        controller.add(chunk);
        await Future.delayed(chunkDelay);
      }
      controller.close();
    });

    return controller.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// Handles errors during stream processing for the response body.
  ///
  /// [onError]: Callback invoked for errors in the stream.
  /// [test]: Optional filter to determine which errors should be handled.
  @override
  Stream<List<int>> handleError(Function onError,
      {bool Function(dynamic error)? test}) {
    return Stream.fromIterable([fileBytes]).handleError(onError, test: test);
  }

  @override
  bool get isRedirect => false;

  @override
  bool get persistentConnection => false;

  @override
  String get reasonPhrase => "OK";

  @override
  int get contentLength => fileBytes.length;

  @override
  List<RedirectInfo> get redirects => <RedirectInfo>[];
}

/// A mock implementation of [HttpHeaders], used internally to represent HTTP headers
/// for a mock response.
class MockHttpHeaders extends Mock implements HttpHeaders {
  /// The `Content-Type` header of the response.
  @override
  final ContentType contentType;

  /// Creates an instance of [MockHttpHeaders] with the specified content type.
  ///
  /// [responseContentType]: The MIME type of the response, as a [ContentType] object.
  MockHttpHeaders({
    required ContentType responseContentType,
  }) : contentType = responseContentType;
}
