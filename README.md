




## 数据定义


```数据定义
import 'package:mbus/m_bus.dart';

void main() {
  // mSimpleEvent 示例
  print('--- mSimpleEvent 示例 ---');
  mSimpleEvent.putEventListen(1, (eventID, data) {
    print('mSimpleEvent 收到事件 $eventID，数据：$data');
  });

  mSimpleEvent.executeEvent(1, {'message': 'Hello from mSimpleEvent!'});
  mSimpleEvent.removeEventListen(1);
  mSimpleEvent.clearAll();

  // mEvent 示例
  print('\n--- mEvent 示例 ---');
  mEvent.putEventListen('moduleA', 101, (eventID, uuid, data) {
    print('mEvent (moduleA) 收到事件 $eventID，UUID: $uuid, 数据：$data');
  });

  mEvent.putEventListen('moduleB', 102, (eventID, uuid, data) {
    print('mEvent (moduleB) 收到事件 $eventID，UUID: $uuid, 数据：$data');
  });

  mEvent.executeModuleEvent('moduleA', 101, 'uuid-123', {'message': 'Hello from moduleA!'});
  mEvent.executeModuleEvent('moduleB', 102, 'uuid-456', {'message': 'Hello from moduleB!'});

  mEvent.removeEventListen('moduleA', 101);
  mEvent.removeModule('moduleB');
  mEvent.clearAll();
}
```

## 使用方法
```


  ```
