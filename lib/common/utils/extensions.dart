import 'package:drill_events/app/features/create_edit_event/create_event_screen.dart';
import 'package:drill_events/app/features/create_edit_event/edit_event_screen.dart';
import 'package:drill_events/app/features/event/event_screen_args.dart';
import 'package:drill_events/app/features/org/org_screen.dart';
import 'package:drill_events/app/features/spot/spot_screen.dart';
import 'package:drill_events/app/new_models/models.dart';
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

  void pop<T>() => Navigator.pop<T>(this);

  Future<T?> openEventScreen<T>({required String eventID, String? orgId}) =>
      Navigator.pushNamed<T>(this, Routes.event, arguments: EventScreenArgs(eventID, orgId: orgId));

  Future<T?> openProfileScreen<T>() => Navigator.pushNamed<T>(this, Routes.profile);

  Future<T?> openSpotScreen<T>(String spotID) =>
      Navigator.pushNamed<T>(this, Routes.spot, arguments: SpotScreenArgs(spotID));

  Future<T?> openOrgScreen<T>(String orgID) =>
      Navigator.pushNamed<T>(this, Routes.org, arguments: OrgScreenArgs(orgID));

  Future<T?> openBottomSheet<T>(Widget child, {VoidCallback? onDidPop}) =>
      Navigator.push<T>(this, AppModalBottomSheetPage<T>(onDidPop: onDidPop, child: child).createRoute(this));

  Future<T?> openCreateEventScreen<T>(String orgId) =>
      Navigator.pushNamed<T>(this, Routes.createEvent, arguments: CreateEventArgs(orgId));

  Future<T?> openEditEventScreen<T>(DetailEventModel event) =>
      Navigator.pushNamed(this, Routes.editEvent, arguments: EditEventsArgs(event));
}
