import 'package:drill_events/app/features/event/event_screen.dart';
import 'package:drill_events/app/features/org_screen.dart';
import 'package:drill_events/app/features/spot/spot_screen.dart';
import 'package:drill_events/common/di/dependencies.dart';
import 'package:drill_events/common/di/dependencies_scope.dart';
import 'package:drill_events/common/navigation/modal_bottom_sheet.dart';
import 'package:drill_events/common/navigation/routes.dart';
import 'package:flutter/material.dart';

extension DateTimeUtils on DateTime {
  String toRFC3337Date() => toIso8601String().split("T")[0];
  String toRFC3337Time() => toIso8601String().split("T")[1].split("+")[0];
}

extension ContextExt on BuildContext {
  Dependencies get dependencies => DependenciesScope.of(this).dependencies;
}

extension Routing on BuildContext {
  T getArgs<T>() => ModalRoute.of(this)!.settings.arguments as T;

  Future<T?> openEventScreen<T>(String eventID) =>
      Navigator.pushNamed<T>(this, Routes.event, arguments: EventScreenArgs(eventID));

  Future<T?> openProfileScreen<T>() => Navigator.pushNamed<T>(this, Routes.profile);

  Future<T?> openSpotScreen<T>(String spotID) =>
      Navigator.pushNamed<T>(this, Routes.spot, arguments: SpotScreenArgs(spotID));

  Future<T?> openOrgScreen<T>(String orgID) =>
      Navigator.pushNamed<T>(this, Routes.org, arguments: OrgScreenArgs(orgID));

  Future<T?> openBottomSheet<T>(Widget child) =>
      Navigator.push<T>(this, AppModalBottomSheetPage<T>(child: child).createRoute(this));

  Future<T?> openCreateEventScreen<T>() => Navigator.pushNamed<T>(this, Routes.createEvent);
}
