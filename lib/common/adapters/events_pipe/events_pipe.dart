import 'dart:async';

import 'package:drill_events/common/adapters/events_pipe/pipe_events.dart' show PipeEvent;
import 'package:drill_events/common/ports/pipe.dart';

class EventsPipe implements Pipe {
  EventsPipe() : _controller = StreamController<PipeEvent>.broadcast();

  final StreamController<PipeEvent> _controller;

  @override
  void listen(void Function(PipeEvent onData) callBack) {
    _controller.stream.listen(callBack);
  }

  @override
  void publish(PipeEvent event) => _controller.add(event);
}
