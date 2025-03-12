import 'package:cached_network_image/cached_network_image.dart';
import 'package:drill_events/app/blocs/auth.dart';
import 'package:drill_events/app/blocs/detail_org.dart';
import 'package:drill_events/app/blocs/detail_org_list_section.dart';
import 'package:drill_events/app/blocs/manage_spot_subscription.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/app_company_logo.dart';
import 'package:drill_events/app/features/widgets/event_status_label.dart';
import 'package:drill_events/app/features/widgets/interpunct.dart';
import 'package:drill_events/app/features/widgets/screen_header.dart';
import 'package:drill_events/app/features/widgets/shimmer.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OrgScreenArgs {
  OrgScreenArgs(this.orgId);

  final String orgId;
}

class OrgScreen extends StatefulWidget {
  const OrgScreen({super.key});

  static Widget bloc(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DetailOrgBloc(context.dependencies.backendApi, context.dependencies.logger)),
        BlocProvider(
          create:
              (_) =>
                  DetailOrgListSectionBloc(api: context.dependencies.backendApi, logger: context.dependencies.logger),
        ),
        BlocProvider(
          create:
              (_) =>
                  ManageSpotSubscriptionBloc(logger: context.dependencies.logger, api: context.dependencies.backendApi),
        ),
      ],
      child: const OrgScreen(),
    );
  }

  @override
  State<OrgScreen> createState() => _OrgScreenState();
}

enum _Tab { events, spots }

class _OrgScreenState extends State<OrgScreen> {
  final _scrollController = ScrollController();
  _Tab _openedTab = _Tab.events;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = context.getArgs<OrgScreenArgs>();

    context.read<DetailOrgBloc>().add(FetchDetailOrg(args.orgId));
    context.read<DetailOrgListSectionBloc>().add(FetchDetailOrgLists(args.orgId));
  }

  void _switchTab(_Tab tab) {
    setState(() => _openedTab = tab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.themes.main.colors.inverse,
      body: BlocListener<ManageSpotSubscriptionBloc, ManageSpotSubscriptionState>(
        listener: (context, state) {
          if (state.isDone) {
            final orgId = context.getArgs<OrgScreenArgs>().orgId;
            context.read<DetailOrgListSectionBloc>().add(FetchDetailOrgLists(orgId));
          }
        },
        child: BlocBuilder<DetailOrgBloc, DetailOrgState>(
          builder: (context, state) {
            if (state.hasError) {
              // TODO:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Произошла ошибка",
                              style: context.themes.main.texts.h3.copyWith(color: context.themes.main.colors.error600),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Error ${state.errorMessage}",
                              style: context.themes.main.texts.body.copyWith(
                                color: context.themes.main.colors.error600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      AppButton.primary(title: "Назад", onTap: () => Navigator.pop(context)),
                    ],
                  ),
                ),
              );
            }

            final isPending = state.isIdle || state.isPending;

            return Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(28, 82, 28, 24),
                      sliver: SliverList.list(
                        children: [
                          // TODO: добавить плавность
                          isPending
                              ? _ContentSection.shimmer()
                              : _ContentSection(
                                tab: _openedTab,
                                switchTab: _switchTab,
                                title: state.value.title,
                                description: state.value.description,
                              ),
                        ],
                      ),
                    ),
                    // TODO: постараться вынести
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: BlocBuilder<DetailOrgListSectionBloc, DetailOrgListSectionState>(
                        builder: (context, sectionState) {
                          if (sectionState.hasError) {
                            // TODO: сделать компонент ошибки для списка
                            return SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 28),
                                child: Text(
                                  sectionState.errorMessage.toString(),
                                  style: context.themes.main.texts.bodySmall.copyWith(
                                    color: context.themes.main.colors.error600,
                                  ),
                                ),
                              ),
                            );
                          }

                          if (sectionState.isIdle || sectionState.isPending) {
                            return SliverList.separated(
                              itemCount: 5,
                              itemBuilder: (context, index) => _EventListItem.shimmer(context),
                              separatorBuilder: (context, index) => const SizedBox(height: 20),
                            );
                          }

                          if (_openedTab == _Tab.events) {
                            final events = sectionState.value.events;

                            return SliverList.separated(
                              itemCount: events.length,
                              itemBuilder: (context, index) {
                                final event = events[index];

                                return _EventListItem(
                                  availableSeats: event.availableSeats,
                                  startDate: event.startDate,
                                  startTime: event.startTime,
                                  bookingModel: event.booking,
                                  title: event.title,
                                  onTap: () => context.openEventScreen(event.id),
                                );
                              },
                              separatorBuilder: (context, index) => const SizedBox(height: 20),
                            );
                          }

                          final spots = sectionState.value.spots;

                          // TODO: change to SpotListItem when it's ready
                          return SliverList.separated(
                            itemCount: spots.length,
                            itemBuilder: (context, index) {
                              final spot = spots[index];

                              return _SpotListItem(
                                id: spot.id,
                                title: spot.title,
                                address: spot.address,
                                city: spot.city ?? '',
                                isSubscribe: spot.subscribed ?? false,
                              );
                            },
                            separatorBuilder: (context, index) => const SizedBox(height: 20),
                          );
                        },
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                ),
                PositionedScreenHeader(isPending: isPending, controller: _scrollController),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  const _ContentSection({required this.tab, required this.title, required this.description, required this.switchTab});

  final _Tab tab;
  final String title;
  final String description;
  final Function(_Tab) switchTab;

  @override
  Widget build(BuildContext context) {
    final activeTabStyle = context.themes.main.texts.h3;
    final tabStyle = activeTabStyle.copyWith(color: context.themes.main.colors.secondary);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AppCompanyLogo(dimension: 150),
                const SizedBox(height: 24),
                Text(title, style: context.themes.main.texts.h1),
              ],
            ),
          ],
        ),
        const SizedBox(height: 28),
        // TODO: вынести в JsonConverter
        Text(description.replaceAll('\\n', '\n'), style: context.themes.main.texts.body),
        const SizedBox(height: 48),
        // TODO: create separate widget for this
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => switchTab(_Tab.events),
              child: Text("События", style: tab == _Tab.events ? activeTabStyle : tabStyle),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => switchTab(_Tab.spots),
              child: Text("Споты", style: tab == _Tab.spots ? activeTabStyle : tabStyle),
            ),
          ],
        ),
      ],
    );
  }

  static Widget shimmer() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Shimmer(height: 32, width: 260),
      const SizedBox(height: 7),
      const Shimmer(height: 21, width: 180),
      const SizedBox(height: 28),
      AppButton.shimmer(),
      const SizedBox(height: 32),
      const Shimmer(height: 25),
      const SizedBox(height: 2),
      const Shimmer(height: 25),
      const SizedBox(height: 2),
      const Shimmer(height: 25, width: 160),
      const SizedBox(height: 48),
      const Shimmer(height: 24, width: 100),
      const SizedBox(height: 24),
      const Shimmer(height: 70),
      const SizedBox(height: 20),
      const Shimmer(height: 70),
    ],
  );
}

class _EventListItem extends StatelessWidget {
  const _EventListItem({
    required this.startDate,
    required this.startTime,
    required this.title,
    required this.availableSeats,
    this.imgUrl,
    this.onTap,
    this.bookingModel,
  });

  final String title;
  final String? imgUrl;
  final VoidCallback? onTap;
  final ShortBookingModel? bookingModel;
  final DateTime startTime;
  final DateTime startDate;
  final int availableSeats;

  EventStatus get _eventStatus {
    if (bookingModel?.approved == null) return EventStatus.processing;
    return bookingModel?.approved == true ? EventStatus.success : EventStatus.decline;
  }

  String get _time => DateFormat('HH:mm').format(startTime);

  String get _date => DateFormat('dd MMMM').format(startDate);

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;
    final colors = context.themes.main.colors;

    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: '',
            errorWidget:
                (_, __, ___) => Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(color: context.themes.main.colors.secondary, shape: BoxShape.circle),
                ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (bookingModel != null) ...[EventStatusLabel(status: _eventStatus), const SizedBox(height: 4)],
                Text(title, style: context.themes.main.texts.body.copyWith(fontWeight: FontWeight.w600, height: 1.3)),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (startDate.difference(DateTime.now()) < const Duration(days: 1))
                      Text('Завтра', style: texts.bodySmall)
                    else
                      Text(_date, style: texts.bodySmall),
                    const SizedBox(width: 8),
                    const Interpunct(),
                    const SizedBox(width: 8),
                    Text(_time, style: texts.bodySmall),
                    const Spacer(),
                    if (availableSeats <= 0) Text('Мест нет', style: texts.bodySmall.copyWith(color: colors.secondary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget shimmer(BuildContext context) => Row(
    children: [
      const Shimmer(height: 52, width: 52, borderRadius: 100),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Shimmer(height: 23, borderRadius: 6),
            const SizedBox(height: 4),
            Shimmer(height: 23, width: MediaQuery.sizeOf(context).width * 0.3, borderRadius: 6),
          ],
        ),
      ),
      const SizedBox(width: 40),
    ],
  );
}

class _SpotListItem extends StatelessWidget {
  const _SpotListItem({
    required this.id,
    required this.city,
    required this.title,
    required this.address,
    this.imgPath,
    this.isSubscribe = false,
  });

  final String title, address, city, id;
  final String? imgPath;
  final bool isSubscribe;

  String get _address => city.isNotEmpty ? '$city, $address' : address;

  @override
  Widget build(BuildContext context) {
    final isAuth = context.read<AuthBloc>().state.hasValue;
    return InkWell(
      onTap: () => context.openSpotScreen(id),
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: '',
            errorWidget:
                (_, __, ___) => Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(color: context.themes.main.colors.secondary, shape: BoxShape.circle),
                ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.themes.main.texts.body.copyWith(fontWeight: FontWeight.w600, height: 1.3)),
                const SizedBox(height: 8),
                Text(_address, style: context.themes.main.texts.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isAuth)
            if (isSubscribe)
              AppButton.secondary(
                title: 'Отписаться',
                onTap: () => context.read<ManageSpotSubscriptionBloc>().add(UnsubscribeEvent(id)),
              )
            else
              AppButton.primary(
                onTap: () => context.read<ManageSpotSubscriptionBloc>().add(SubscribeEvent(id)),
                title: 'Подписаться',
              ),
        ],
      ),
    );
  }
}
