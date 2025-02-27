import 'package:drill_events/common/adapters/events_pipe/pipe_events.dart';

abstract interface class Pipe {
  void listen(void Function(PipeEvent data) callBack);
  void publish(PipeEvent events);
}
