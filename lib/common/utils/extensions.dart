import 'package:drill_events/common/di/dependencies.dart';
import 'package:drill_events/common/di/dependencies_scope.dart';
import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  Dependencies get dependencies => DependenciesScope.of(this).dependencies;
}
