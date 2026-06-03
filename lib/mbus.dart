/// mbus - A lightweight event bus library for Flutter applications
///
/// This library provides two event management systems:
/// - [mSimpleEvent]: A simple global event bus for basic event broadcasting
/// - [mEvent]: A module-based event bus for organized event management in complex applications
/// - [mDebugDebug]: Debug logging utilities for monitoring event bus activity
///
/// Example usage:
/// ```dart
/// import 'package:mbus/m_bus.dart';
///
/// // Simple event bus
/// mSimpleEvent.putEventListen(1, (eventID, data) {
///   print('Event received: $data');
/// });
/// mSimpleEvent.executeEvent(1, {'message': 'Hello'});
///
/// // Module-based event bus
/// mEvent.putEventListen('module_name', 101, (eventID, uuid, data) {
///   print('Module event received: $data');
/// });
/// mEvent.executeModuleEvent('module_name', 101, 'uuid', {'message': 'Hello'});
/// ```

export 'src/m_debug.dart';
export 'src/m_event.dart';
export 'src/m_event_simple.dart';
