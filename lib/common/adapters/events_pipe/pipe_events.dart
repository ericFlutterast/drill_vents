import 'package:drill_events/app/new_models/models.dart';

abstract class PipeEvent {}

final class BookPipeEvent extends PipeEvent {
  BookPipeEvent(this.booking);

  final BookingModel booking;
}

final class UpdateUserDataPipeEvent extends PipeEvent {}

final class UpdateOrgScreenData extends PipeEvent {
  UpdateOrgScreenData(this.orgId);
  final String orgId;
}
