import 'm_debug.dart';

/// Type definition for simple event callbacks
///
/// This typedef defines the signature for callbacks that handle simple events.
/// The callback receives the event ID and associated data.
///
/// Parameters:
///   - [eventID]: The integer identifier of the event that triggered this callback
///   - [data]: A Map containing the event payload data
///
/// Example:
/// ```dart
/// EventCallbackSimple myCallback = (eventID, data) {
///   print('Event $eventID received with data: $data');
/// };
/// ```
typedef EventCallbackSimple = void Function(int eventID, Map<String, dynamic> data);

/// Simple event listener data container
///
/// This class encapsulates event listener information for the simple event bus.
/// It stores the event ID and its associated callback function.
///
/// This is an internal class used by [mSimpleEvent]. You typically won't instantiate
/// this class directly.
class EventListenSimpleData {
  /// The event ID this listener is registered for
  final int eventID;

  /// The callback function to invoke when the event is triggered
  final EventCallbackSimple eventCallback;

  /// Creates an event listener data instance
  ///
  /// Parameters:
  ///   - [eventID]: Unique event identifier
  ///   - [eventCallback]: Callback function to execute when event triggers
  EventListenSimpleData({required this.eventID, required this.eventCallback});
}

/// Simple global event bus for lightweight event broadcasting
///
/// [mSimpleEvent] provides a straightforward event bus implementation suitable for
/// simple applications or scenarios where you don't need module-based organization.
///
/// Key characteristics:
/// - Simple and lightweight
/// - Global event management (no module separation)
/// - Easy to use with minimal configuration
/// - Suitable for small to medium-sized applications
///
/// For complex applications with multiple features, consider using [mEvent] instead,
/// which supports module-based event organization.
///
/// Example usage:
/// ```dart
/// // Register a listener
/// mSimpleEvent.putEventListen(101, (eventID, data) {
///   print('Event $eventID received: $data');
/// });
///
/// // Trigger the event
/// mSimpleEvent.executeEvent(101, {'message': 'Hello World'});
///
/// // Clean up
/// mSimpleEvent.removeEventListen(101);
/// mSimpleEvent.clearAll(); // Clear all listeners
/// ```
class mSimpleEvent {
  /// Internal storage for all registered event listeners
  static final List<EventListenSimpleData> _listeners = [];

  /// Register a listener for a specific event
  ///
  /// This method adds a new event listener. Multiple listeners can be registered
  /// for the same event ID - all will be called when the event is triggered.
  ///
  /// Parameters:
  ///   - [eventID]: Unique integer identifier for the event
  ///   - [callback]: The callback function to execute when event is triggered
  ///
  /// Note: Currently, duplicate listeners can be registered. To avoid this,
  /// check if a listener already exists before registering.
  ///
  /// Example:
  /// ```dart
  /// mSimpleEvent.putEventListen(1, (eventID, data) {
  ///   print('Listener 1 called');
  /// });
  ///
  /// mSimpleEvent.putEventListen(1, (eventID, data) {
  ///   print('Listener 2 called');
  /// });
  ///
  /// mSimpleEvent.executeEvent(1, {}); // Both listeners will be called
  /// ```
  static void putEventListen(int eventID, EventCallbackSimple callback) {
    _listeners.add(EventListenSimpleData(eventID: eventID, eventCallback: callback));
    mDebugDebug.log('✅ Registered event: $eventID');
  }

  /// Trigger an event and notify all registered listeners
  ///
  /// This method executes all callbacks registered for the specified event ID
  /// and passes the provided data to each callback.
  ///
  /// Parameters:
  ///   - [eventID]: The event identifier to trigger
  ///   - [data]: Event payload data to pass to callbacks
  ///
  /// Behavior:
  /// - If no listeners are registered for this event, nothing happens
  /// - All matching listeners are called synchronously in registration order
  /// - If a callback throws an exception, it will propagate
  ///
  /// Example:
  /// ```dart
  /// mSimpleEvent.executeEvent(1, {
  ///   'message': 'Hello',
  ///   'timestamp': DateTime.now(),
  ///   'userId': 123
  /// });
  /// ```
  static void executeEvent(int eventID, Map<String, dynamic> data) {
    for (var listener in _listeners) {
      if (listener.eventID == eventID) {
        listener.eventCallback(eventID, data);
      }
    }
    mDebugDebug.log('🔔 Event triggered: $eventID with data: $data');
  }

  /// Remove a listener for a specific event
  ///
  /// This method unregisters all listeners for the specified event ID.
  /// If multiple listeners are registered for the same event, all are removed.
  ///
  /// Parameters:
  ///   - [eventID]: The event identifier to remove listeners for
  ///
  /// Example:
  /// ```dart
  /// mSimpleEvent.putEventListen(1, callback1);
  /// mSimpleEvent.putEventListen(1, callback2);
  ///
  /// mSimpleEvent.removeEventListen(1); // Both listeners are removed
  /// ```
  static void removeEventListen(int eventID) {
    _listeners.removeWhere((e) => e.eventID == eventID);
    mDebugDebug.log('🗑️ Removed event: $eventID');
  }

  /// Remove all registered listeners
  ///
  /// This method clears all event listeners from the bus. After calling this,
  /// the event bus will be completely empty.
  ///
  /// Use this method for cleanup in application shutdown or widget disposal.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// void dispose() {
  ///   mSimpleEvent.clearAll();
  ///   super.dispose();
  /// }
  /// ```
  static void clearAll() {
    _listeners.clear();
    mDebugDebug.log('🧼 All event listeners cleared');
  }
}

// TODO: Example usage commented out - uncomment to test
// void main() {
//   // Register event listeners
//   mSimpleEvent.putEventListen(1, (eventID, data) {
//     print('Event received: $eventID, Data: $data');
//   });
//
//   // Trigger the event
//   mSimpleEvent.executeEvent(1, {'message': 'Hello, EventBus!'});
//
//   // Remove listener
//   mSimpleEvent.removeEventListen(1);
//
//   // Clear all listeners
//   mSimpleEvent.clearAll();
// }
