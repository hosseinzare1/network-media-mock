import 'dart:nativewrappers/_internal/vm/lib/developer.dart';

import 'package:flutter/foundation.dart';

class NetworkMediaMockLogger {
  static void printSuccess(String message) {
    if (kDebugMode) {
      log(message, name: "NetworkMediaMock Success");
    }
  }

  static void printError(String message) {
    if (kDebugMode) {
      log(message, name: "NetworkMediaMock Error");
    }
  }
}
