import 'package:flicker_free/app/common/global.dart';

class GlobalEvent {
  final EventType type;
  final dynamic data;

  GlobalEvent(this.type, [this.data]);
}

enum EventType { toggle, fullScreen, previous, next, forward, backward }

void fireGlobalEvent(EventType type, [dynamic data]) {
  eventBus.fire(GlobalEvent(type, data));
}
