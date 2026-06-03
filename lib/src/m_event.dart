import 'm_debug.dart';

/// Type definition for module-based event callbacks
///
/// This typedef defines the signature for callbacks that handle module-based events.
/// The callback receives the event ID, a unique identifier (UUID), and associated data.
///
/// Parameters:
///   - [eventID]: The integer identifier of the event within the module
///   - [uuid]: A unique identifier for this event trigger, useful for tracking
///   - [data]: A Map containing the event payload data
///
/// Example:
/// ```dart
/// EventCallback myCallback = (eventID, uuid, data) {
///   print('Event $eventID (uuid: $uuid) received with data: $data');
/// };
/// ```
typedef EventCallback = void Function(int eventID, String uuid, Map<String, dynamic> data);

/// Module-based event listener data container
///
/// This class encapsulates event listener information for the module-based event bus.
/// It stores the module name, event ID, and its associated callback function.
///
/// This is an internal class used by [mEvent]. You typically won't instantiate
/// this class directly.
class EventListenData {
  /// The name of the module this listener belongs to
  final String moduleName;

  /// The event ID within the module
  final int eventID;

  /// The callback function to invoke when the event is triggered
  final EventCallback eventCallback;

  /// Creates an event listener data instance
  ///
  /// Parameters:
  ///   - [moduleName]: Name identifier for the module
  ///   - [eventID]: Event identifier within the module
  ///   - [eventCallback]: Callback function to execute when event triggers
  EventListenData({required this.moduleName, required this.eventID, required this.eventCallback});
}

/// Module-based event bus for organized event management
///
/// [mEvent] provides a more sophisticated event bus implementation suitable for
/// complex applications. It organizes events by modules, allowing better separation
/// of concerns and clearer event organization.
///
/// Key characteristics:
/// - Module-based organization (separate events per module)
/// - Module namespace isolation
/// - UUID tracking for event triggers
/// - Scalable for medium to large applications
/// - Prevents duplicate event registration within a module
///
/// For simple applications without module requirements, consider using [mSimpleEvent] instead.
///
/// Example usage:
/// ```dart
/// // Register listeners for different modules
/// mEvent.putEventListen('user', 201, (eventID, uuid, data) {
///   print('User module event: $eventID');
/// });
///
/// mEvent.putEventListen('profile', 301, (eventID, uuid, data) {
///   print('Profile module event: $eventID');
/// });
///
/// // Trigger events
/// mEvent.executeModuleEvent('user', 201, 'trigger-uuid-1', {'action': 'login'});
///
/// // Clean up
/// mEvent.removeEventListen('user', 201);
/// mEvent.removeModule('profile');
/// mEvent.clearAll();
/// ```
class mEvent {
  /// Internal storage for all registered event listeners organized by module
  ///
  /// Structure: Map<moduleName, List<EventListenData>>
  static final Map<String, List<EventListenData>> _moduleListeners = {};

  /// Register a listener for a specific module event
  ///
  /// This method adds a new event listener to the specified module. The library
  /// prevents duplicate event registration - if a listener for the same event ID
  /// already exists in the module, the new registration is ignored.
  ///
  /// Parameters:
  ///   - [moduleName]: The name of the module (e.g., 'auth', 'profile', 'payment')
  ///   - [eventID]: Unique integer identifier for the event within the module
  ///   - [callback]: The callback function to execute when event is triggered
  ///
  /// Behavior:
  /// - Creates a new module entry if it doesn't exist
  /// - Prevents duplicate registration for the same event ID within a module
  /// - Outputs debug information when enabled
  ///
  /// Example:
  /// ```dart
  /// mEvent.putEventListen('auth', 1001, (eventID, uuid, data) {
  ///   print('Auth event: login successful');
  /// });
  ///
  /// // Attempting to register the same event twice will be ignored
  /// mEvent.putEventListen('auth', 1001, (eventID, uuid, data) {
  ///   print('This won\'t be called');
  /// });
  /// ```
  static void putEventListen(String moduleName, int eventID, EventCallback callback) {
    final listeners = _moduleListeners.putIfAbsent(moduleName, () => []);

    // Prevent duplicate registration
    if (listeners.any((e) => e.eventID == eventID)) {
      mDebugDebug.log('⚠️ [$moduleName] Event already registered: $eventID, ignoring duplicate');
      return;
    }

    listeners.add(EventListenData(moduleName: moduleName, eventID: eventID, eventCallback: callback));
    mDebugDebug.log('✅ [$moduleName] Registered event: $eventID');
  }

  /// Trigger an event for a specific module
  ///
  /// This method executes all callbacks registered for the specified event ID
  /// within the given module. Each matching listener is called synchronously
  /// with the event ID, UUID, and data.
  ///
  /// Parameters:
  ///   - [moduleName]: The module name containing the event
  ///   - [eventID]: The event identifier within the module
  ///   - [uuid]: A unique identifier for this event trigger (for tracking/correlation)
  ///   - [data]: Event payload data to pass to callbacks
  ///
  /// Behavior:
  /// - If the module doesn't exist, the event is silently ignored (with debug log)
  /// - Only callbacks registered for the exact event ID are called
  /// - Callbacks are called synchronously in registration order
  /// - If a callback throws an exception, it will propagate
  ///
  /// Example:
  /// ```dart
  /// mEvent.executeModuleEvent('user', 201, 'evt-12345', {
  ///   'userId': '123',
  ///   'username': 'john_doe',
  ///   'timestamp': DateTime.now(),
  /// });
  /// ```
  static void executeModuleEvent(String moduleName, int eventID, String uuid, Map<String, dynamic> data) {
    final listeners = _moduleListeners[moduleName];
    if (listeners == null) {
      mDebugDebug.log('❌ [$moduleName] No event listeners registered for this module');
      return;
    }

    bool found = false;
    for (var listener in listeners) {
      if (listener.eventID == eventID) {
        listener.eventCallback(eventID, uuid, data);
        found = true;
      }
    }

    if (found) {
      mDebugDebug.log('🔔 [$moduleName] Event triggered: $eventID (UUID: $uuid)');
    } else {
      mDebugDebug.log('⚠️ [$moduleName] Event $eventID not found in registered listeners');
    }
  }

  /// Remove a listener for a specific module event
  ///
  /// This method unregisters the listener for a specific event ID within a module.
  /// After removal, the module is removed if it has no more listeners.
  ///
  /// Parameters:
  ///   - [moduleName]: The module name
  ///   - [eventID]: The event identifier to remove
  ///
  /// Behavior:
  /// - Removes the listener for the specified event ID
  /// - If no listeners remain for the module, the module entry is removed
  /// - Silently ignores if the module or event doesn't exist
  /// - Outputs debug information when enabled
  ///
  /// Example:
  /// ```dart
  /// mEvent.removeEventListen('auth', 1001);
  ///
  /// // In a widget's dispose method
  /// @override
  /// void dispose() {
  ///   mEvent.removeEventListen('myModule', 101);
  ///   super.dispose();
  /// }
  /// ```
  static void removeEventListen(String moduleName, int eventID) {
    final listeners = _moduleListeners[moduleName];
    if (listeners == null) return;

    listeners.removeWhere((e) => e.eventID == eventID);
    if (listeners.isEmpty) _moduleListeners.remove(moduleName);
    mDebugDebug.log('🗑️ [$moduleName] Removed event: $eventID');
  }

  /// Remove all listeners for a specific module
  ///
  /// This method unregisters all event listeners for the specified module,
  /// completely removing the module from the event bus.
  ///
  /// Parameters:
  ///   - [moduleName]: The module name to clear
  ///
  /// Example:
  /// ```dart
  /// // When a feature is disabled or the app section is closed
  /// mEvent.removeModule('payment');
  /// ```
  static void removeModule(String moduleName) {
    if (_moduleListeners.containsKey(moduleName)) {
      _moduleListeners.remove(moduleName);
      mDebugDebug.log('🧹 Removed all listeners for module: [$moduleName]');
    }
  }

  /// Remove all registered listeners from all modules
  ///
  /// This method clears the entire event bus, removing all modules and their
  /// associated listeners. Use this method for application cleanup or global reset.
  ///
  /// Example:
  /// ```dart
  /// // Called during app shutdown or reset
  /// mEvent.clearAll();
  ///
  /// // In a global logout scenario
  /// void logout() {
  ///   mEvent.clearAll();
  ///   // Reinitialize event listeners as needed
  /// }
  /// ```
  static void clearAll() {
    _moduleListeners.clear();
    mDebugDebug.log('🧼 All event listeners and modules cleared');
  }
}

// TODO: Example usage commented out - uncomment to test module-based events
// void main() {
//   // Register module-based event listeners
//   mEvent.putEventListen('moduleA', 101, (eventID, uuid, data) {
//     print('ModuleA received event $eventID (UUID: $uuid), Data: $data');
//   });
//
//   mEvent.putEventListen('moduleB', 102, (eventID, uuid, data) {
//     print('ModuleB received event $eventID (UUID: $uuid), Data: $data');
//   });
//
//   // Trigger events for specific modules
//   mEvent.executeModuleEvent('moduleA', 101, 'uuid-123', {'message': 'Hello from moduleA!'});
//   mEvent.executeModuleEvent('moduleB', 102, 'uuid-456', {'message': 'Hello from moduleB!'});
//
//   // Remove specific event listener
//   mEvent.removeEventListen('moduleA', 101);
//
//   // Remove all listeners for a module
//   mEvent.removeModule('moduleB');
//
//   // Clear all listeners
//   mEvent.clearAll();
// }
