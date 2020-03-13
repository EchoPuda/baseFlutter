
import 'package:event_bus/event_bus.dart';

/// 监听器
/// @author jm
class TestEventBus {

  static final TestEventBus _gInstance = TestEventBus._init();

  EventBus _eventBus = EventBus();

  TestEventBus._init() {
    ///
  }

  factory TestEventBus() {
    return _gInstance;
  }

  EventBus get bus {
    return _eventBus;
  }

}

/// 事件
class RefreshEvent {
  String data;

  RefreshEvent({this.data});
}