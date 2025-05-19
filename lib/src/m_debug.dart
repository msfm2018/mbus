import 'package:flutter/foundation.dart';

class mDebugDebug {
  static bool isEnabled = false;

  static void log(String message) {
    if (kDebugMode && isEnabled) {
      final now = DateTime.now().toIso8601String();
      debugPrint("[mDebug] $message:::$now");
    }
  }
}
