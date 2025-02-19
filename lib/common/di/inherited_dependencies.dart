import 'package:drill_events/common/di/dependencies.dart';
import 'package:flutter/cupertino.dart';

final class InheritedDependencies extends InheritedWidget {
  const InheritedDependencies({super.key, required super.child, required Dependencies dependencies})
    : _dependencies = dependencies;

  final Dependencies _dependencies;

  Dependencies get dependencies => _dependencies;

  static InheritedDependencies? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedDependencies>();
  }

  static InheritedDependencies of(BuildContext context) {
    final widget = maybeOf(context);
    assert(widget != null, "This context don't contains this widget");
    return widget!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
