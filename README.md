# mbus

A lightweight and efficient event bus library for Flutter applications. mbus provides a simple yet powerful event-driven architecture with support for both simple and module-based event management.

## Features

- **Lightweight**: Minimal dependencies and small package size
- **Simple API**: Easy-to-use interfaces for event registration and triggering
- **Flexible**: Two event management modes - simple global events or module-based events
- **Type-Safe**: Leverages Dart's type system for safer event handling
- **Debug-Friendly**: Built-in debug logging capabilities
- **No Boilerplate**: Quick setup without complex configuration

## Installation

Add mbus to your `pubspec.yaml`:

```yaml
dependencies:
  mbus: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### Simple Event Bus (mSimpleEvent)

The `mSimpleEvent` is perfect for lightweight applications or simple event scenarios where you don't need module separation.

```dart
import 'package:mbus/m_bus.dart';

void main() {
  // Register a listener for event ID 1
  mSimpleEvent.putEventListen(1, (eventID, data) {
    print('Received event $eventID with data: $data');
  });

  // Trigger the event
  mSimpleEvent.executeEvent(1, {'message': 'Hello from mSimpleEvent!'});

  // Remove the listener
  mSimpleEvent.removeEventListen(1);

  // Clear all listeners
  mSimpleEvent.clearAll();
}
```

### Module-Based Event Bus (mEvent)

The `mEvent` is ideal for complex applications where you want to organize events by modules or features.

```dart
import 'package:mbus/m_bus.dart';

void main() {
  // Register listeners for different modules
  mEvent.putEventListen('moduleA', 101, (eventID, uuid, data) {
    print('moduleA received event $eventID (UUID: $uuid) with data: $data');
  });

  mEvent.putEventListen('moduleB', 102, (eventID, uuid, data) {
    print('moduleB received event $eventID (UUID: $uuid) with data: $data');
  });

  // Trigger events for specific modules
  mEvent.executeModuleEvent('moduleA', 101, 'uuid-123', {'message': 'Hello from moduleA!'});
  mEvent.executeModuleEvent('moduleB', 102, 'uuid-456', {'message': 'Hello from moduleB!'});

  // Remove specific event listener
  mEvent.removeEventListen('moduleA', 101);

  // Remove all listeners for a module
  mEvent.removeModule('moduleB');

  // Clear all listeners
  mEvent.clearAll();
}
```

## API Reference

### mSimpleEvent

Global event bus for simple event broadcasting without module separation.

#### Methods

- **putEventListen(int eventID, EventCallbackSimple callback)**
  - Register a listener for a specific event ID
  - Parameters:
    - `eventID`: Unique integer identifier for the event
    - `callback`: Function to execute when event is triggered

- **executeEvent(int eventID, Map<String, dynamic> data)**
  - Trigger an event and notify all registered listeners
  - Parameters:
    - `eventID`: Event identifier to trigger
    - `data`: Event payload data

- **removeEventListen(int eventID)**
  - Unregister a listener for a specific event ID
  - Parameters:
    - `eventID`: Event identifier to remove

- **clearAll()**
  - Remove all registered listeners

### mEvent

Module-based event bus for organizing events by modules or features.

#### Methods

- **putEventListen(String moduleName, int eventID, EventCallback callback)**
  - Register a listener for a module's specific event
  - Parameters:
    - `moduleName`: Name of the module
    - `eventID`: Event identifier within the module
    - `callback`: Function to execute when event is triggered

- **executeModuleEvent(String moduleName, int eventID, String uuid, Map<String, dynamic> data)**
  - Trigger an event for a specific module
  - Parameters:
    - `moduleName`: Target module name
    - `eventID`: Event identifier
    - `uuid`: Unique identifier for this event trigger
    - `data`: Event payload data

- **removeEventListen(String moduleName, int eventID)**
  - Unregister a listener for a module's event
  - Parameters:
    - `moduleName`: Module name
    - `eventID`: Event identifier to remove

- **removeModule(String moduleName)**
  - Remove all listeners for a specific module
  - Parameters:
    - `moduleName`: Module name to clear

- **clearAll()**
  - Remove all registered listeners and modules

### Debug Logging

Enable debug logging to monitor event bus activity:

```dart
import 'package:mbus/m_bus.dart';

void main() {
  // Enable debug logging
  mDebugDebug.isEnabled = true;

  // Now all event bus operations will be logged
  mSimpleEvent.putEventListen(1, (eventID, data) {
    print('Event received');
  });

  mSimpleEvent.executeEvent(1, {'message': 'test'});
}
```

## Usage Patterns

### Pattern 1: UI State Updates

```dart
// In your UI layer
mSimpleEvent.putEventListen(100, (eventID, data) {
  setState(() {
    appState = data['state'];
  });
});

// In your business logic
mSimpleEvent.executeEvent(100, {'state': newState});
```

### Pattern 2: Module Communication

```dart
// Module A broadcasts data
mEvent.putEventListen('moduleA', 1001, (eventID, uuid, data) {
  // Handle moduleA events
});

// Module B receives data from Module A
mEvent.executeModuleEvent('moduleA', 1001, 'trigger-uuid', 
  {'dataFromB': 'value'});
```

### Pattern 3: Cross-Feature Events

```dart
class AuthModule {
  static void init() {
    mEvent.putEventListen('auth', 2001, (eventID, uuid, data) {
      if (data['action'] == 'login') {
        handleLogin(data);
      }
    });
  }
}

class NavigationModule {
  static void notifyLogin(Map<String, dynamic> userInfo) {
    mEvent.executeModuleEvent('auth', 2001, 'nav-trigger', 
      {'action': 'login', 'user': userInfo});
  }
}
```

## Best Practices

1. **Use Consistent Event IDs**: Define event ID constants for better maintainability
   ```dart
   class EventIds {
     static const int LOGIN_SUCCESS = 1001;
     static const int LOGOUT = 1002;
   }
   ```

2. **Module-Based Organization**: Use mEvent for large applications with multiple features
   ```dart
   mEvent.putEventListen('auth', EventIds.LOGIN_SUCCESS, callback);
   ```

3. **Clean Up**: Always remove listeners when they're no longer needed
   ```dart
   @override
   void dispose() {
     mEvent.removeEventListen('moduleName', eventId);
     super.dispose();
   }
   ```

4. **Type Your Data**: Use typed Maps to ensure consistency
   ```dart
   Map<String, dynamic> eventData = {
     'userId': '123',
     'timestamp': DateTime.now(),
   };
   ```

5. **Enable Debug Logging During Development**: Useful for troubleshooting event flow
   ```dart
   mDebugDebug.isEnabled = kDebugMode;
   ```

## Troubleshooting

### Events Not Being Triggered

1. Check if the listener is registered with the correct event ID
2. Ensure the listener hasn't been removed
3. Enable debug logging to verify event triggering:
   ```dart
   mDebugDebug.isEnabled = true;
   ```

### Memory Leaks

Always remove listeners when they're no longer needed, especially in dispose methods:

```dart
@override
void dispose() {
  mEvent.removeEventListen('moduleName', eventId);
  super.dispose();
}
```

## Limitations

- Event listeners are stored in memory; large numbers of listeners may impact performance
- No built-in persistence; events in transit are lost if the app closes
- Single-process only (no inter-process communication)

## Performance Considerations

- Use event ID constants instead of magic numbers
- Consider using module-based events (mEvent) for large applications
- Batch similar events when possible
- Profile your application to ensure event bus overhead is acceptable

## Migration Guide

If you're upgrading from an older version:

- All comments have been translated to English
- API remains backward compatible
- Debug logging now uses emoji indicators for clarity
- Consider migrating to module-based events for better scalability

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues, questions, or suggestions, please open an issue on GitHub:
https://github.com/msfm2018/mbus/issues

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and updates.
