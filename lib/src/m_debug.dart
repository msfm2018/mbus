import 'package:flutter/foundation.dart';

/// Debug logging utility class for mbus event bus system
///
/// This class provides debug-time logging capabilities to monitor and troubleshoot
/// event bus operations. Logs are only output in debug mode when explicitly enabled.
///
/// Usage:
/// ```dart
/// // Enable debug logging
/// mDebugDebug.isEnabled = true;
///
/// // Now all event operations will be logged
/// mSimpleEvent.putEventListen(1, callback);
/// // Output: [mDebug] ✅ Registered event: 1:::2024-01-15T10:30:45.123456Z
/// ```
class mDebugDebug {
  /// Controls whether debug logging is enabled
  ///
  /// When set to true, all event bus operations will output debug information.
  /// This is only effective in debug mode (kDebugMode must be true).
  ///
  /// Example:
  /// ```dart
  /// mDebugDebug.isEnabled = kDebugMode; // Enable in debug builds
  /// ```
  static bool isEnabled = false;

  /// Log a debug message with timestamp
  ///
  /// This method outputs a formatted debug message with the current timestamp
  /// only if both [isEnabled] is true and [kDebugMode] is true.
  ///
  /// Parameters:
  ///   - [message]: The debug message to log
  ///
  /// The output format is: `[mDebug] {message}:::{ISO8601 timestamp}`
  ///
  /// Example emoji indicators used in logs:
  ///   - ✅ : Successful operation (registration, binding)
  ///   - ❌ : Error condition (listener not found)
  ///   - 🗑️ : Removal operation (unbinding)
  ///   - 🧹 : Module cleanup (remove module)
  ///   - 🧼 : Complete cleanup (clear all)
  ///   - ⚠️ : Warning (duplicate registration)
  ///
  /// Example:
  /// ```dart
  /// mDebugDebug.log('✅ Event listener registered');
  /// // Output: [mDebug] ✅ Event listener registered:::2024-01-15T10:30:45.123456Z
  /// ```
  static void log(String message) {
    if (kDebugMode && isEnabled) {
      final now = DateTime.now().toIso8601String();
      debugPrint("[mDebug] $message:::$now");
    }
  }
}
