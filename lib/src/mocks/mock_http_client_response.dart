import 'dart:async';
import 'dart:io';
import 'package:mockito/mockito.dart';

/// Mock implementation for simulating a successful HTTP response.
class MockHttpClientResponse extends Mock implements HttpClientResponse {
  final List<int> fileBytes;
  final String contentType;

  MockHttpClientResponse({
    required this.fileBytes,
    required this.contentType,
  });

  @override
  int get statusCode => HttpStatus.ok;

  @override
  HttpHeaders get headers {
    final ContentType responseContentType = ContentType.parse(contentType);
    final headers = MockHttpHeaders(responseContentType: responseContentType);
    return headers;
  }

  @override
  Future<Socket> detachSocket() {
    throw UnimplementedError("detachSocket is not implemented in the mock.");
  }

  @override
  StreamSubscription<List<int>> listen(void Function(List<int>)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    final controller = StreamController<List<int>>();
    if (onData != null) {
      controller.add(fileBytes);
    }
    controller.close();

    return controller.stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  Stream<List<int>> handleError(Function onError, {bool Function(dynamic error)? test}) {
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

class MockHttpHeaders extends Mock implements HttpHeaders {
  MockHttpHeaders({
    required ContentType responseContentType,
  }) : contentType = responseContentType;

  @override
  final ContentType contentType;
}
