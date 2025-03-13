import 'package:cached_network_image/cached_network_image.dart';
import 'package:drill_events/app/blocs/auth.dart';
import 'package:drill_events/app/blocs/detail_spot.dart';
import 'package:drill_events/app/blocs/manage_spot_subscription.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/event_status_label.dart';
import 'package:drill_events/app/features/widgets/interpunct.dart';
import 'package:drill_events/app/features/widgets/screen_header.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SpotScreenArgs {
  SpotScreenArgs(this.spotId);

  final String spotId;
}

class SpotScreen extends StatefulWidget {
  const SpotScreen({super.key});

  static Widget bloc(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailSpotBloc>(
          create: (_) => DetailSpotBloc(context.dependencies.backendApi, context.dependencies.logger),
        ),
        BlocProvider<ManageSpotSubscriptionBloc>(
          create:
              (_) =>
                  ManageSpotSubscriptionBloc(logger: context.dependencies.logger, api: context.dependencies.backendApi),
        ),
      ],
      child: const SpotScreen(),
    );
  }

  @override
  State<SpotScreen> createState() => _SpotScreenState();
}

class _SpotScreenState extends State<SpotScreen> {
  //TODO: сделать какой-то swicher
  bool _isAdmin = false;
  bool _isAuth = false;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _isAuth = context.read<AuthBloc>().state.hasValue;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = context.getArgs<SpotScreenArgs>();
    final bloc = context.read<DetailSpotBloc>();
    bloc.add(FetchDetailSpot(args.spotId));
  }

  void _onTapSubscribe() {
    final spotId = context.getArgs<SpotScreenArgs>().spotId;
    context.read<ManageSpotSubscriptionBloc>().add(SubscribeEvent(spotId));
  }

  void _onTapUnsubscribe() {
    final spotId = context.getArgs<SpotScreenArgs>().spotId;
    context.read<ManageSpotSubscriptionBloc>().add(UnsubscribeEvent(spotId));
  }

  void _onTapEvent(String eventID) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.themes.main.colors.inverse,
      body: BlocListener<ManageSpotSubscriptionBloc, ManageSpotSubscriptionState>(
        listener: (context, state) {
          if (state.isDone) {
            final spotId = context.getArgs<SpotScreenArgs>().spotId;
            context.read<DetailSpotBloc>().add(FetchDetailSpot(spotId));
          }
        },
        child: Stack(
          children: [
            BlocBuilder<DetailSpotBloc, DetailSpotState>(
              builder: (context, state) {
                if (state.hasError) {
                  // TODO:
                  return Expanded(child: Text("Error ${state.errorMessage}"));
                }

                if (state.isPending) {
                  // TODO:
                  return const Text("Pending");
                }

                if (state.isIdle) {
                  // TODO:
                  return const Text("Idle");
                }

                final spot = state.value.spot;

                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(28, 180, 28, 24),
                      sliver: SliverList.list(
                        children: [
                          Text(spot.title, style: context.themes.main.texts.h1),
                          const SizedBox(height: 7),
                          Text(spot.address, style: context.themes.main.texts.bodySmall),
                          const SizedBox(height: 28),
                          if (_isAdmin)
                            AppButton.primary(
                              title: "Добавить событие",
                              //TODO: Переход на создание ивента и добавление автоматом в этот спот
                              onTap: () => context.openCreateEventScreen(),
                            )
                          else if (_isAuth) ...[
                            if (state.hasValue && state.value.spot.subscribed == true)
                              AppButton.secondary(title: "Отписаться", onTap: _onTapUnsubscribe)
                            else
                              AppButton.primary(title: "Подписаться", onTap: _onTapSubscribe),
                            const SizedBox(height: 32),
                          ],

                          // TODO: вынести в JsonConverter
                          Text(spot.description.replaceAll('\\n', '\n'), style: context.themes.main.texts.body),
                          const SizedBox(height: 48),
                          Text("События", style: context.themes.main.texts.h3),
                        ],
                      ),
                    ),
                    SliverList.separated(
                      itemCount: state.value.events.length,
                      itemBuilder: (context, index) {
                        final event = state.value.events.elementAt(index);

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _EventListItem(
                            title: event.title,
                            onTap: () => _onTapEvent(event.id),
                            startDate: event.startDate,
                            startTime: event.startTime,
                            availableSeats: event.availableSeats,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 20),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                );
              },
            ),
            PositionedScreenHeader(controller: _scrollController, onTapLogo: () {}),
          ],
        ),
      ),
    );
  }
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
}
