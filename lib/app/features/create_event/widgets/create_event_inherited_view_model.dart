import 'package:drill_events/app/models/new_event_model.dart';
import 'package:flutter/material.dart';

final class CreateEventInheritedViewModel extends InheritedWidget {
  const CreateEventInheritedViewModel({super.key, required super.child, required this.model});

  static NewEventViewModel? maybeOf(BuildContext context, {bool listen = false}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<CreateEventInheritedViewModel>()?.model;
    } else {
      final widget = context.getElementForInheritedWidgetOfExactType<CreateEventInheritedViewModel>()?.widget;
      assert(widget != null && widget is CreateEventInheritedViewModel, "This context doesn't contains this widget");
      return (widget as CreateEventInheritedViewModel).model;
    }
  }

  final NewEventViewModel model;

  @override
  bool updateShouldNotify(CreateEventInheritedViewModel oldWidget) => false;
}
