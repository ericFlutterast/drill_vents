import 'package:drill_events/app/blocs/detail_event_admin.dart';
import 'package:drill_events/app/features/event/event_screen_args.dart';
import 'package:drill_events/app/features/event/widgets/date_time_info.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/app_icon_button.dart';
import 'package:drill_events/app/features/widgets/interpunct.dart';
import 'package:drill_events/app/features/widgets/screen_header.dart';
import 'package:drill_events/app/features/widgets/shimmer.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocProvider(
      create:
          (context) => EventDetailAdminBloc(
            cache: context.dependencies.fastCache,
            repository: context.dependencies.backendApi,
            logger: context.dependencies.logger,
          ),
      child: const EventAdminScreen(),
    );
  }

  @override
  State<EventAdminScreen> createState() => _EventAdminScreenState();
}

enum _Tab { detailEvent, participants }

class _EventAdminScreenState extends State<EventAdminScreen> {
  late final _controller = ScrollController();

  _Tab _currentTab = _Tab.detailEvent;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final eventId = context.getArgs<EventScreenArgs>().eventId;
    context.read<EventDetailAdminBloc>().add(FetchDetailEventAdmin(eventId));
  }

  void _openEdinEventScreen() {
    final event = context.read<EventDetailAdminBloc>().state.value.event;
    context.openEditEventScreen(event);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    final texts = context.themes.main.texts;

    return Scaffold(
      backgroundColor: colors.inverse,
      body: BlocBuilder<EventDetailAdminBloc, EventDetailAdminState>(
        builder: (context, state) {
          if (state.isPending) return EventAdminScreen.shimmer(context);

          if (state.isDone && state.hasValue) {
            return Stack(
              children: [
                if (_currentTab == _Tab.participants)
                  _TabBuilder(
                    child: CustomScrollView(
                      controller: _controller,
                      slivers: [
                        const SliverPadding(padding: EdgeInsets.only(top: 180)),
                        _ParticipantsListTab(
                          participants: state.value.participants,
                          capacity: state.value.event.capacity,
                        ),
                      ],
                    ),
                  ),
                if (_currentTab == _Tab.detailEvent)
                  _TabBuilder(
                    child: CustomScrollView(
                      controller: _controller,
                      slivers: [
                        const SliverPadding(padding: EdgeInsets.only(top: 180)),
                        SliverToBoxAdapter(
                          child: _ContentSection(
                            eventName: state.value.event.title,
                            description: state.value.event.description,
                            orgName: state.value.event.org.title,
                            spotName: state.value.event.spot.title,
                            startTime: state.value.event.startTime,
                            startDate: state.value.event.startDate,
                            address: '${state.value.event.spotCity ?? ''}, ${state.value.event.spot.address}',
                          ),
                        ),
                        const SliverPadding(padding: EdgeInsets.only(top: 24)),
                        if (true) //TODO: state.value.participants.isNotEmpty
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 28),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: 'Участники ',
                                      style: texts.body.copyWith(fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                          text: '(${state.value.event.availableSeats}/${state.value.event.capacity})',
                                          style: texts.body.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: colors.secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AppButton.secondary(
                                    title: 'Показать всех',
                                    onTap: () => _changeTab(_Tab.participants),
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        const SliverPadding(padding: EdgeInsets.only(top: 18)),
                        SliverList.separated(
                          itemCount: state.value.participants.length,
                          itemBuilder: (context, index) {
                            final item = state.value.participants.elementAt(index);

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: _UserListItem(title: item.name ?? '', mail: item.email),
                            );
                          },
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: AppButton.primary(onTap: () {}, title: 'Рассмотреть заявки'),
                          ),
                        ),
                        const SliverPadding(padding: EdgeInsets.only(top: 30)),
                      ],
                    ),
                  ),

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
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _backButtonHandler() {
    if (_currentTab == _Tab.participants) {
      _changeTab(_Tab.detailEvent);
    } else {
      context.pop();
    }
  }

  void _changeTab(_Tab tab) {
    setState(() => _currentTab = tab);
  }
}

class _ContentSection extends StatelessWidget {
  const _ContentSection({
    required this.eventName,
    required this.description,
    required this.orgName,
    required this.spotName,
    required this.startTime,
    required this.startDate,
    required this.address,
    this.onTapOrg,
    this.onTapSpot,
  });

  final VoidCallback? onTapOrg;
  final VoidCallback? onTapSpot;
  final String eventName, spotName, orgName, description, address, startDate, startTime;

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (orgName.isNotEmpty && spotName.isNotEmpty)
            Row(
              children: [
                GestureDetector(onTap: onTapOrg, child: Text(orgName, style: texts.bodySmall)),
                const SizedBox(width: 8),
                const Interpunct(),
                const SizedBox(width: 8),
                GestureDetector(onTap: onTapSpot, child: Text(spotName, style: texts.bodySmall)),
              ],
            ),
          const SizedBox(height: 7),
          Text(eventName, style: texts.h1),
          const SizedBox(height: 38),
          DateTimeInfo(address: address, startTime: startTime, date: startDate),
          const SizedBox(height: 32),
          Text(description, style: texts.body),
        ],
      ),
    );
  }
}

class _ParticipantsListTab extends StatelessWidget {
  const _ParticipantsListTab({required this.participants, required this.capacity});

  final Iterable<ShortUserModel> participants;
  final int capacity;

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;
    final colors = context.themes.main.colors;

    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Row(
            children: [
              Text('Участники ', style: texts.h1),
              Text('(${participants.length}/$capacity)', style: texts.h3.copyWith(color: colors.secondary)),
            ],
          ),
        ),
        const SizedBox(height: 28),
        for (final item in participants) ...[
          _UserListItem(title: item.name ?? '', mail: item.email),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 28),
      ]),
    );
  }
}

class _UserListItem extends StatelessWidget {
  const _UserListItem({required this.title, required this.mail});

  final String title, mail;

  static Widget shimmer() {
    return const Row(
      children: [
        Shimmer(borderRadius: 100, height: 52, width: 52),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Shimmer(height: 18, width: 200), SizedBox(width: 3), Shimmer(height: 18, width: 150)],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;
    final colors = context.themes.main.colors;

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(height: 52, width: 52, decoration: BoxDecoration(color: colors.secondary, shape: BoxShape.circle)),
          // CachedNetworkImage(
          //   imageUrl: '',
          //   errorWidget:
          //       (_, __, ___) => Container(
          //         height: 52,
          //         width: 52,
          //         decoration: BoxDecoration(color: colors.secondary, shape: BoxShape.circle),
          //       ),
          // ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: texts.body.copyWith(fontWeight: FontWeight.w600, height: 1.3),
                  ),
                ),

                Expanded(child: Text(mail, maxLines: 2, overflow: TextOverflow.ellipsis, style: texts.bodySmall)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBuilder extends StatelessWidget {
  const _TabBuilder({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      key: UniqueKey(),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (_, value, __) => Opacity(opacity: value, child: child),
      onEnd: () {},
    );
  }
}
