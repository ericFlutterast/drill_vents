import 'package:drill_events/app/features/spot/spot_screen.dart';
import 'package:drill_events/common/di/dependencies.dart';
import 'package:drill_events/common/di/dependencies_scope.dart';
import 'package:drill_events/common/navigation/routes.dart';
import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  Dependencies get dependencies => DependenciesScope.of(this).dependencies;
  T getArgs<T>() => ModalRoute.of(this)!.settings.arguments as T;

  Future openSpotScreen(String spotID) => Navigator.pushNamed(this, Routes.spot, arguments: SpotScreenArgs(spotID));
}
