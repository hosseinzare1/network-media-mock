import 'dart:nativewrappers/_internal/vm/lib/developer.dart';

class NetworkMediaMockLogger {
  final bool isLogEnabled;

  const NetworkMediaMockLogger({required this.isLogEnabled});

  void printSuccess(String message) {
    if (isLogEnabled) {
      log(message, name: "NetworkMediaMock Success");
    }
  }

  void printError(String message) {
    if (isLogEnabled) {
      log(message, name: "NetworkMediaMock Error");
    }
  }
}
