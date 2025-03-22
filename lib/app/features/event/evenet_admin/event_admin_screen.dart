import 'dart:math';

import 'package:drill_events/app/blocs/detail_event_admin.dart';
import 'package:drill_events/app/blocs/moderation_users.dart';
import 'package:drill_events/app/features/event/evenet_admin/tabs/tab_builder.dart';
import 'package:drill_events/app/features/event/event_screen_args.dart';
import 'package:drill_events/app/features/event/widgets/date_time_info.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/app_icon_button.dart';
import 'package:drill_events/app/features/widgets/app_notification.dart';
import 'package:drill_events/app/features/widgets/interpunct.dart';
import 'package:drill_events/app/features/widgets/notification_manager.dart';
import 'package:drill_events/app/features/widgets/screen_header.dart';
import 'package:drill_events/app/features/widgets/shimmer.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tabs/detail_event_tab.dart';
part 'tabs/participants_tab.dart';
part 'tabs/requests_tab.dart';
part 'tabs/tabs_enum.dart';

class EventAdminScreen extends StatefulWidget {
  const EventAdminScreen({super.key});

  static Widget shimmer(BuildContext context) {
    final deviceSize = MediaQuery.sizeOf(context);

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          const Shimmer(height: 42, width: 42, borderRadius: 100),
          const SizedBox(height: 50),
          Shimmer(height: 20, width: deviceSize.width * 0.5),
          const SizedBox(height: 7),
          Shimmer(height: 50, width: deviceSize.width * 0.7),
          const SizedBox(height: 60),
          Shimmer(height: 40, width: deviceSize.width),
          const SizedBox(height: 32),
          for (int i = 0; i < 5; i++) ...[
            Shimmer(height: 12, width: i == 4 ? deviceSize.width * 0.7 : deviceSize.width),
            const SizedBox(height: 2),
          ],
          const SizedBox(height: 24),
          Shimmer(height: 24, width: deviceSize.width * 0.4),
          const SizedBox(height: 18),
          for (int i = 0; i < 5; i++) ...[_UserListItem.shimmer(), const SizedBox(height: 12)],
        ],
      ),
    );
  }

  static Widget bloc(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => EventDetailAdminBloc(
                cache: context.dependencies.fastCache,
                repository: context.dependencies.backendApi,
                logger: context.dependencies.logger,
              ),
        ),
        BlocProvider(
          create: (_) => ModerationUsersBloc(logger: context.dependencies.logger, api: context.dependencies.backendApi),
        ),
      ],
      child: const EventAdminScreen(),
    );
  }

  @override
  State<EventAdminScreen> createState() => _EventAdminScreenState();
}

class _EventAdminScreenState extends State<EventAdminScreen> {
  late final _controller = ScrollController();

  _Tab _currentTab = _Tab.detailEvent;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final eventId = context.getArgs<EventScreenArgs>().eventId;
    context.read<EventDetailAdminBloc>().add(FetchDetailEventAdmin(eventId));
    context.read<ModerationUsersBloc>().add(FetchUserForModerationEvent(eventId));
  }

  void _openEdinEventScreen() {
    final event = context.read<EventDetailAdminBloc>().state.value.event;
    context.openEditEventScreen(event);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    return PrimaryScrollController(
      controller: _controller,
      child: Scaffold(
        backgroundColor: colors.inverse,
        body: Stack(
          children: [
            switch (_currentTab) {
              _Tab.checkRequests => const _RequestsTab(),
              _Tab.participants => const _ParticipantsListTab(),
              _Tab.detailEvent => _DetailEventTab(
                onShowParticipants: () => _switchTab(_Tab.participants),
                onShowRequests: () => _switchTab(_Tab.checkRequests),
              ),
            },

            PositionedScreenHeader(
              controller: _controller,
              onTapLogo: () {},
              backButtonHandler: _backButtonHandler,
              actions: [
                const SizedBox(width: 12),
                AppIconButton(icon: CupertinoIcons.pencil, onTap: _openEdinEventScreen, dimension: 42),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _backButtonHandler() {
    if (_currentTab == _Tab.participants || _currentTab == _Tab.checkRequests) {
      _switchTab(_Tab.detailEvent);
    } else {
      context.pop();
    }
  }

  void _switchTab(_Tab tab) {
    _controller.jumpTo(0);
    setState(() => _currentTab = tab);
  }
}
