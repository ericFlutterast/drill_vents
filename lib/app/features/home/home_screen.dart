import 'package:cached_network_image/cached_network_image.dart';
import 'package:drill_events/app/blocs/auth.dart';
import 'package:drill_events/app/blocs/feed_events.dart';
import 'package:drill_events/app/features/scroll_physics/loading_scroll_physic.dart';
import 'package:drill_events/app/features/scroll_physics/pagination_scroll_physic.dart';
import 'package:drill_events/app/features/widgets/animated_refresh.dart';
import 'package:drill_events/app/features/widgets/app_avatar.dart';
import 'package:drill_events/app/features/widgets/app_text_field.dart';
import 'package:drill_events/app/features/widgets/circle_avatar_decoration.dart';
import 'package:drill_events/app/features/widgets/event_status_label.dart';
import 'package:drill_events/app/features/widgets/interpunct.dart';
import 'package:drill_events/app/features/widgets/shimmer.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/navigation/routes.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Widget bloc(BuildContext context) {
    return BlocProvider<EventsBloc>(
      create:
          (_) => EventsBloc(
            repository: context.dependencies.backendApi,
            logger: context.dependencies.logger,
            fileStorage: context.dependencies.fileStorage,
            pipe: context.dependencies.pipe,
          ),
      child: const HomeScreen(),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<EventsBloc>().add(FetchEventsFeed());
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final delta = _scrollController.position.viewportDimension * 0.1;
    final isPending = context.read<EventsBloc>().state.isPending;
    if (_scrollController.offset >= maxScrollExtent - delta && !isPending) {
      context.read<EventsBloc>().add(PaginationEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            int countsLength = 10;
            ScrollPhysics physics = const BouncingScrollPhysics();
            if (state.hasValue) {
              countsLength = state.isPagination ? state.value.events.length + 8 : state.value.events.length;
            }
            if (state.isPending) {
              physics = const LoadingScrollPhysic();
            }
            if (state.isPagination) {
              physics = const PaginationScrollPhysic();
            }

            return CustomScrollView(
              controller: _scrollController,
              physics: physics,
              slivers: [
                SliverAppBar(
                  collapsedHeight: MediaQuery.sizeOf(context).height * 0.1,
                  surfaceTintColor: context.themes.main.colors.inverse,
                  backgroundColor: context.themes.main.colors.inverse,
                  expandedHeight: 120,
                  pinned: true,
                  flexibleSpace: const FlexibleSpaceBar(
                    expandedTitleScale: 1,
                    title: _HomeHeader(),
                    titlePadding: EdgeInsets.only(bottom: 10),
                  ),
                ),
                CupertinoSliverRefreshControl(
                  refreshIndicatorExtent: 60,
                  refreshTriggerPullDistance: 170,
                  onRefresh: () async => context.read<EventsBloc>().add(FetchEventsFeed()),
                  builder: (context, _, pullExtent, __, ___) {
                    return pullExtent > 85 ? const Center(child: AnimatedRefresh()) : const SizedBox.shrink();
                  },
                ),
                const _SoonEventsTitle(),
                if (state.isPending)
                  SliverList.separated(
                    itemCount: 20,
                    itemBuilder:
                        (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _EventListItem.shimmer(context),
                        ),
                    separatorBuilder: (_, __) => const SizedBox(height: 28),
                  )
                else if (state.hasValue) ...[
                  SliverList.separated(
                    itemCount: countsLength,
                    itemBuilder: (context, index) {
                      if (index > state.value.events.length - 1) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _EventListItem.shimmer(context),
                        );
                      }

                      final EventCardModel event = state.value.events.elementAt(index);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _EventListItem(
                          title: event.title,
                          booking: event.booking,
                          organizationName: event.org.title,
                          spotName: event.spot.title,
                          onTap: () => context.openEventScreen(eventID: event.id, orgId: event.org.id),
                          startDate: event.startDate,
                          availableSeats: event.availableSeats,
                          imgUrl: event.spot.imageUrl,
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 28),
                  ),
                  const SliverPadding(padding: EdgeInsets.only(top: 30)),
                ] else if (state.hasValue && state.value.events.isEmpty || state.hasError)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.2),
                        child: Text(
                          'Не удалось загрузить: ${state.errorMessage}',
                          style: context.themes.main.texts.body,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AppTextField(
              hintText: 'Поиск...',
              onChanged: (value) {
                if (value.isEmpty) {
                  context.read<EventsBloc>().add(FetchEventsFeed());
                } else {
                  context.read<EventsBloc>().add(SearchEvents(value: value));
                }
              },
            ),
          ),
          const SizedBox(width: 20),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state.isPending) return const Shimmer(height: 38, width: 38, borderRadius: 38);

              if (!state.hasValue) {
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, Routes.profile),
                  child: Icon(Icons.person, size: 30, color: colors.secondary),
                );
              }

              return CircleAvatarDecoration(
                onTap: () => Navigator.pushNamed(context, Routes.profile),
                child:
                    state.value.userAvatar != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: SizedBox.square(
                            dimension: 38,
                            child: CachedNetworkImage(
                              imageUrl: state.value.userAvatar!,
                              fit: BoxFit.fill,
                              progressIndicatorBuilder: (context, _, progress) {
                                return const Shimmer(height: 38, width: 38, borderRadius: 38);
                              },
                            ),
                          ),
                        )
                        : Icon(Icons.person, size: 30, color: colors.secondary),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SoonEventsTitle extends StatelessWidget {
  const _SoonEventsTitle();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 35, 28, 28),
        child: Text('Ближайшие события', style: context.themes.main.texts.body),
      ),
    );
  }
}

class _EventListItem extends StatelessWidget {
  const _EventListItem({
    required this.title,
    required this.organizationName,
    required this.spotName,
    required this.startDate,
    required this.availableSeats,
    this.booking,
    this.onTap,
    this.imgUrl,
  });

  final String title;
  final String? imgUrl;
  final VoidCallback? onTap;
  final DateTime startDate;
  final String spotName;
  final String organizationName;
  final ShortBookingModel? booking;
  final int availableSeats;

  EventStatus get _eventStatus {
    if (booking?.approved == null) return EventStatus.processing;
    return booking?.approved == true ? EventStatus.success : EventStatus.decline;
  }

  String get _date => DateFormat('dd MMMM').format(startDate);

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;
    final colors = context.themes.main.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppAvatar(imageUrl: imgUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (booking != null) EventStatusLabel(status: _eventStatus),
                const SizedBox(height: 4),
                Text(title, style: texts.body.copyWith(fontWeight: FontWeight.w600, height: 1.3)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      startDate.difference(DateTime.now()) < const Duration(days: 1) ? 'Завтра' : _date,
                      style: texts.bodySmall,
                    ),
                    const SizedBox(width: 8),
                    const Interpunct(),
                    const SizedBox(width: 8),
                    Text(spotName, style: texts.bodySmall),
                    const Spacer(),
                    //TODO: availableSeats >= capacity
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
