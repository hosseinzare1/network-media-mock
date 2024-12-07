import 'package:flutter/foundation.dart';

/// A utility class for logging messages related to network media mocking.
///
/// This class provides methods to log success and error messages during
/// the mocking process. Logging is controlled by the [isLogEnabled] flag.
class NetworkMediaMockLogger {
  final bool isLogEnabled;

  const NetworkMediaMockLogger({required this.isLogEnabled});

  void printSuccess(String message) {
    if (isLogEnabled) {
      if (kDebugMode) print(message);
    }
  }

  void printError(String message) {
    if (isLogEnabled) {
      if (kDebugMode) print(message);
    }
  }
}
