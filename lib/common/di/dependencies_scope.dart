import 'package:drill_events/common/di/dependencies.dart';
import 'package:flutter/cupertino.dart';

final class DependenciesScope extends InheritedWidget {
  const DependenciesScope({super.key, required super.child, required this.dependencies});

  final Dependencies dependencies;

  static DependenciesScope? maybeOf(BuildContext context, [bool listen = false]) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<DependenciesScope>();
    } else {
      final widget = context.getElementForInheritedWidgetOfExactType<DependenciesScope>()?.widget;
      assert(widget is DependenciesScope?, 'this widget is not DependenciesScope');
      return (widget as DependenciesScope?);
    }
  }

  static DependenciesScope of(BuildContext context, [bool listen = false]) {
    final widget = maybeOf(context, listen);
    assert(widget != null, "This context don't contains this widget");
    return widget!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
