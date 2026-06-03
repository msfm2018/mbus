# mbus Example Application

This example demonstrates how to use the mbus event bus library in a Flutter application.

## Overview

The example app showcases both event bus implementations:
- **Simple Event Bus** (mSimpleEvent) - for basic event broadcasting
- **Module-Based Event Bus** (mEvent) - for organized event management

## Getting Started

### Prerequisites
- Flutter SDK >= 1.17.0
- Dart SDK >= 3.0.6

### Installation

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the example:
   ```bash
   flutter run
   ```

## Features Demonstrated

### 1. Simple Event Bus Usage

```dart
import 'package:mbus/m_bus.dart';

void demonstrateSimpleEventBus() {
  // Enable debug logging to see operations
  mDebugDebug.isEnabled = true;

  // Register a listener for event ID 1
  mSimpleEvent.putEventListen(1, (eventID, data) {
    print('Simple event received: Event #$eventID');
    print('Data: $data');
  });

  // Trigger the event
  mSimpleEvent.executeEvent(1, {
    'message': 'Hello from simple event bus!',
    'timestamp': DateTime.now(),
  });

  // Clean up
  mSimpleEvent.removeEventListen(1);
}
```

### 2. Module-Based Event Bus Usage

```dart
import 'package:mbus/m_bus.dart';

void demonstrateModuleBasedEventBus() {
  mDebugDebug.isEnabled = true;

  // Register listeners for different modules
  mEvent.putEventListen('auth', 1001, (eventID, uuid, data) {
    print('Auth module event: $eventID');
    print('User: ${data['username']}');
  });

  mEvent.putEventListen('notifications', 2001, (eventID, uuid, data) {
    print('Notification event: $eventID');
    print('Message: ${data['message']}');
  });

  // Trigger events
  mEvent.executeModuleEvent('auth', 1001, 'evt-001', {
    'username': 'john_doe',
    'action': 'login',
  });

  mEvent.executeModuleEvent('notifications', 2001, 'evt-002', {
    'message': 'You have a new message',
    'count': 5,
  });

  // Clean up
  mEvent.removeModule('auth');
  mEvent.removeModule('notifications');
}
```

### 3. Flutter Widget Integration

```dart
import 'package:flutter/material.dart';
import 'package:mbus/m_bus.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget({Key? key}) : super(key: key);

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    // Register event listener
    mSimpleEvent.putEventListen(100, (eventID, data) {
      setState(() {
        _counter = data['count'] as int;
      });
    });
  }

  @override
  void dispose() {
    // Clean up listeners
    mSimpleEvent.removeEventListen(100);
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    // Broadcast the counter update
    mSimpleEvent.executeEvent(100, {'count': _counter});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Counter Value:'),
        Text(
          '$_counter',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
```

### 4. Multi-Module Communication

```dart
import 'package:mbus/m_bus.dart';

// Module A
class UserModule {
  static const String moduleName = 'user';
  static const int loginEvent = 1001;
  static const int logoutEvent = 1002;

  static void init() {
    mEvent.putEventListen(moduleName, loginEvent, (eventID, uuid, data) {
      print('User logged in: ${data['email']}');
    });

    mEvent.putEventListen(moduleName, logoutEvent, (eventID, uuid, data) {
      print('User logged out');
    });
  }

  static void notifyLogin(String email) {
    mEvent.executeModuleEvent(
      moduleName,
      loginEvent,
      DateTime.now().millisecondsSinceEpoch.toString(),
      {'email': email},
    );
  }

  static void notifyLogout() {
    mEvent.executeModuleEvent(
      moduleName,
      logoutEvent,
      DateTime.now().millisecondsSinceEpoch.toString(),
      {},
    );
  }

  static void cleanup() {
    mEvent.removeModule(moduleName);
  }
}

// Module B
class AnalyticsModule {
  static const String moduleName = 'analytics';
  static const int trackEvent = 2001;

  static void init() {
    // Listen to other modules' events
    mEvent.putEventListen('user', UserModule.loginEvent, (eventID, uuid, data) {
      // Track user login for analytics
      trackUserAction('login', data);
    });
  }

  static void trackUserAction(String action, Map<String, dynamic> data) {
    mEvent.executeModuleEvent(
      moduleName,
      trackEvent,
      DateTime.now().millisecondsSinceEpoch.toString(),
      {
        'action': action,
        'timestamp': DateTime.now(),
        'data': data,
      },
    );
  }

  static void cleanup() {
    mEvent.removeModule(moduleName);
  }
}

void main() {
  // Initialize modules
  UserModule.init();
  AnalyticsModule.init();

  // Trigger events
  UserModule.notifyLogin('user@example.com');
  UserModule.notifyLogout();

  // Cleanup
  UserModule.cleanup();
  AnalyticsModule.cleanup();
}
```

## Best Practices Demonstrated

1. **Enable Debug Logging During Development**
   ```dart
   import 'package:flutter/foundation.dart';
   
   void main() {
     mDebugDebug.isEnabled = kDebugMode;
   }
   ```

2. **Clean Up Listeners in dispose()**
   ```dart
   @override
   void dispose() {
     mSimpleEvent.removeEventListen(eventId);
     super.dispose();
   }
   ```

3. **Use Constants for Event IDs**
   ```dart
   class EventIds {
     static const int LOGIN_SUCCESS = 1001;
     static const int LOGOUT = 1002;
     static const int DATA_REFRESH = 1003;
   }
   ```

4. **Organize by Modules**
   ```dart
   class Modules {
     static const String AUTH = 'auth';
     static const String PROFILE = 'profile';
     static const String PAYMENTS = 'payments';
   }
   ```

5. **Use Typed Data Maps**
   ```dart
   final eventData = <String, dynamic>{
     'userId': '12345',
     'username': 'john_doe',
     'timestamp': DateTime.now(),
   };
   ```

## Running Tests

To test the event bus functionality:

```bash
flutter test
```

## Troubleshooting

### Events Not Being Triggered

1. Check if the listener is registered with the correct event ID
2. Enable debug logging:
   ```dart
   mDebugDebug.isEnabled = true;
   ```
3. Verify the event data format matches expectations

### Memory Issues

1. Always remove listeners when they're no longer needed
2. Use `dispose()` methods in StatefulWidgets
3. Clear all listeners on app exit:
   ```dart
   void logout() {
     mSimpleEvent.clearAll();
     mEvent.clearAll();
   }
   ```

## Additional Resources

- [mbus Documentation](https://pub.dev/packages/mbus)
- [mbus GitHub Repository](https://github.com/msfm2018/mbus)
- [Pub.dev Package Page](https://pub.dev/packages/mbus)
- [Flutter Event Bus Patterns](https://flutter.dev)

## Support

For issues or questions about the example:
1. Check the [mbus documentation](https://pub.dev/packages/mbus)
2. Visit the [GitHub issues page](https://github.com/msfm2018/mbus/issues)
3. Review the troubleshooting section in README.md

## License

This example is part of the mbus package and is licensed under the MIT License.
