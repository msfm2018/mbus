import 'package:mbus/mbus.dart';

void main() {
  // mSimpleEvent example
  print('--- mSimpleEvent Example ---');
  mSimpleEvent.putEventListen(1, (eventID, data) {
    print('mSimpleEvent received event $eventID, data: $data');
  });

  mSimpleEvent.executeEvent(1, {'message': 'Hello from mSimpleEvent!'});
  mSimpleEvent.removeEventListen(1);
  mSimpleEvent.clearAll();

  // mEvent example
  print('\n--- mEvent Example ---');
  mEvent.putEventListen('moduleA', 101, (eventID, uuid, data) {
    print('mEvent (moduleA) received event $eventID, UUID: $uuid, data: $data');
  });

  mEvent.putEventListen('moduleB', 102, (eventID, uuid, data) {
    print('mEvent (moduleB) received event $eventID, UUID: $uuid, data: $data');
  });

  mEvent.executeModuleEvent('moduleA', 101, 'uuid-123', {'message': 'Hello from moduleA!'});
  mEvent.executeModuleEvent('moduleB', 102, 'uuid-456', {'message': 'Hello from moduleB!'});

  mEvent.removeEventListen('moduleA', 101);
  mEvent.removeModule('moduleB');
  mEvent.clearAll();
}
