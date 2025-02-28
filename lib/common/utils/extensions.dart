import 'package:drill_events/app/features/event/event_screen.dart';
import 'package:drill_events/app/features/org/org_screen.dart';
import 'package:drill_events/app/features/spot/spot_screen.dart';
import 'package:drill_events/common/di/dependencies.dart';
import 'package:drill_events/common/di/dependencies_scope.dart';
import 'package:drill_events/common/navigation/modal_bottom_sheet.dart';
import 'package:drill_events/common/navigation/routes.dart';
import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  Dependencies get dependencies => DependenciesScope.of(this).dependencies;
}

extension Routing on BuildContext {
  T getArgs<T>() => ModalRoute.of(this)!.settings.arguments as T;

  Future openEventScreen(String eventID) =>
      Navigator.pushNamed(this, Routes.event, arguments: EventScreenArgs(eventID));
  Future openSpotScreen(String spotID) => Navigator.pushNamed(this, Routes.spot, arguments: SpotScreenArgs(spotID));
  Future openOrgScreen(String orgID) => Navigator.pushNamed(this, Routes.org, arguments: OrgScreenArgs(orgID));

  void openBottomSheet(Widget child) => Navigator.push(this, AppModalBottomSheetPage(child: child).createRoute(this));
}
