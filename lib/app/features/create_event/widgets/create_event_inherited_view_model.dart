import 'package:drill_events/app/models/new_event_model.dart';
import 'package:flutter/material.dart';

final class NewEventInheritedViewModel extends InheritedWidget {
  NewEventInheritedViewModel({super.key, required super.child, required NewEventModel model})
    : stateModel = NewEventState(model);

  static NewEventState of(BuildContext context, {bool listen = false}) {
    if (listen) {
      final state = context.dependOnInheritedWidgetOfExactType<NewEventInheritedViewModel>()?.stateModel;
      assert(state != null, "This context doesn't contains this widget");
      return state!;
    } else {
      final widget = context.getElementForInheritedWidgetOfExactType<NewEventInheritedViewModel>()?.widget;
      assert(widget != null && widget is NewEventInheritedViewModel, "This context doesn't contains this widget");
      return (widget as NewEventInheritedViewModel).stateModel;
    }
  }

  final NewEventState stateModel;

  @override
  bool updateShouldNotify(NewEventInheritedViewModel oldWidget) => false;
}

class NewEventState {
  NewEventState(this.model);

  NewEventModel model;
}
