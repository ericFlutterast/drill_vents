import 'package:drill_events/app/blocs/auth.dart';
import 'package:drill_events/app/blocs/booking_event.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/blocs/detail_event.dart';
import 'package:drill_events/app/features/event/event_screen_args.dart';
import 'package:drill_events/app/features/event/evetn_user/widgets/creating_entry_for_event_modal.dart';
import 'package:drill_events/app/features/event/evetn_user/widgets/prompt_email_password.dart';
import 'package:drill_events/app/features/event/widgets/date_time_info.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/app_notification.dart';
import 'package:drill_events/app/features/widgets/interpunct.dart';
import 'package:drill_events/app/features/widgets/notification_manager.dart';
import 'package:drill_events/app/features/widgets/screen_header.dart';
import 'package:drill_events/app/generated/assets.gen.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/navigation/modal_bottom_sheet.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  static Widget bloc(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailEventBloc>(
          create: (_) {
            final id = context.getArgs<EventScreenArgs>().eventId;
            return DetailEventBloc(
              repository: context.dependencies.backendApi,
              logger: context.dependencies.logger,
              cache: context.dependencies.fastCache,
              pipe: context.dependencies.pipe,
              fileStorage: context.dependencies.fileStorage,
            )..add(FetchDetailEvent(id: id));
          },
        ),
        BlocProvider<BookingEventBloc>(
          create:
              (_) => BookingEventBloc(
                cache: context.dependencies.fastCache,
                repository: context.dependencies.backendApi,
                logger: context.dependencies.logger,
                pipe: context.dependencies.pipe,
              ),
        ),
      ],
      child: const EventScreen(),
    );
  }

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final _loadingBottomSheetName = 'Loading';

  late final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showErrorNotification(String message) {
    NotificationManager.of(
      context,
    ).showNotification(notification: AppNotification(status: NotificationStatus.error, message: message));
    Navigator.popUntil(context, (route) => route.settings.name != _loadingBottomSheetName);
  }

  void _startRegistration() async {
    final userData = await _promptUserData();

    if (userData case [String email, String password]) {
      _startUserRegistration(email, password);
    }
  }

  Future<List<String>> _promptUserData() async {
    return await Navigator.push<List<String>>(
          context,
          const AppModalBottomSheetPage<List<String>>(
            useSafeArea: true,
            child: PromptEmailPassword(
              conditionsForParticipation: [
                'Уровень английского B1 и выше',
                'Уровень китайского 99 и выше',
                'Японское гражданство',
                'Звание глобала и 8к ммр в доте',
              ],
            ),
          ).createRoute(context),
        ) ??
        [];
  }

  void _startUserRegistration(String email, String password) {
    if (mounted) {
      final eventId = context.read<DetailEventBloc>().state.value.id;
      context.read<AuthBloc>().add(CreateAuthBook(password: password, email: email, eventId: eventId));
      Navigator.push(
        context,
        AppModalBottomSheetPage(
          name: _loadingBottomSheetName,
          child: const CreatingEntryForEventModal(),
        ).createRoute(context),
      );
    }
  }

  void _signUpToEventBlocListener(BuildContext context, CommonBlocState<BookingModel> state) {
    if (state.isDone) {
      Navigator.popUntil(context, (route) => route.settings.name != _loadingBottomSheetName);
      Navigator.push(context, const AppModalBottomSheetPage(child: _SignUpDone.success()).createRoute(context));
    }
    if (state.isError) {
      Navigator.popUntil(context, (route) => route.settings.name != _loadingBottomSheetName);
      Navigator.push(context, const AppModalBottomSheetPage(child: _SignUpDone.error()).createRoute(context));
    }
  }

  void _bookToEvent() {
    final userId = context.read<AuthBloc>().state.value.id;
    final eventId = context.read<DetailEventBloc>().state.value.id;
    context.read<BookingEventBloc>().add(BookToEvent(userId: userId, eventId: eventId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.themes.main.colors.inverse,
      body: BlocListener<AuthBloc, CommonBlocState>(
        listener: (context, state) {
          if (state.isDone) {
            context.pop();
          }

          if (state.isError) {
            _showErrorNotification(state.errorMessage.toString());
          }
        },
        child: BlocListener<BookingEventBloc, CommonBlocState<BookingModel>>(
          listener: _signUpToEventBlocListener,
          child: BlocBuilder<DetailEventBloc, DetailEventState>(
            builder: (context, state) {
              return Stack(
                children: [
                  if (state.hasError)
                    const Center(child: Text('Не удалось получить информацию'))
                  else if (state.isDone && state.hasValue)
                    CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        const SliverPadding(padding: EdgeInsets.only(top: 180)),
                        SliverToBoxAdapter(
                          child: _ContentSection(
                            booking: state.value.booking,
                            onTapOrgName: () => context.openOrgScreen(state.value.org.id),
                            onTapSpotName: () => context.openSpotScreen(state.value.spot.id),
                            title: state.value.title,
                            description: state.value.description,
                            orgName: state.value.org.title,
                            spotName: state.value.spot.title,
                            //TODO:
                            requirements: [
                              'Уровень английского B1 и выше',
                              'Уровень китайского 99 и выше',
                              'Японское гражданство',
                              'Звание глобала и 8к ммр в доте',
                            ],
                            //TODO:
                            bonuses: [
                              'Стол и стул (или бутылка)',
                              'Участникам скидка 10% на напитки собственного приготовления 😉',
                            ],
                            startTime: state.value.startTime,
                            address: '${state.value.spotCity}, ${state.value.spot.address}',
                            startDate: state.value.startDate,
                          ),
                        ),
                        const SliverPadding(padding: EdgeInsets.only(top: 42)),
                        _BookingButtonBuilder(
                          builder: (context) {
                            final authState = context.watch<AuthBloc>().state;
                            final bookingState = context.watch<BookingEventBloc>().state;

                            VoidCallback onTap = _bookToEvent;
                            if (!authState.hasValue) {
                              onTap = _startRegistration;
                            }
                            if (state.hasValue && state.value.booking != null ||
                                bookingState.hasValue && bookingState.isDone) {
                              onTap = () {
                                context.openBottomSheet(
                                  _DeclineBookingModal(
                                    userId: authState.value.id,
                                    eventId: state.value.id,
                                    bloc: context.read<BookingEventBloc>(),
                                  ),
                                );
                              };
                              return AppButton.warning(onTap: onTap, title: 'Отменить завявку');
                            }

                            return authState.isPending || bookingState.isPending
                                ? const AppButton.loading(title: 'Идет запись')
                                : AppButton.primary(onTap: onTap, title: 'Записаться');
                          },
                        ),

                        const SliverPadding(padding: EdgeInsets.only(top: 50)),
                      ],
                    ),
                  PositionedScreenHeader(
                    controller: _scrollController,
                    orgAvatarUrl: state.getValueOrNull?.orgAvatar,
                    onTapLogo: () => context.openOrgScreen("7fdb5b3d-9de4-4dbb-a862-1a430feeb7fa"),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  const _ContentSection({
    required this.title,
    required this.description,
    required this.orgName,
    required this.spotName,
    required this.requirements,
    required this.bonuses,
    required this.startTime,
    required this.address,
    required this.startDate,
    required this.booking,
    this.onTapOrgName,
    this.onTapSpotName,
  });

  final String title;
  final String description;
  final String orgName;
  final String spotName;
  final String address;
  final String startDate;
  final String startTime;
  final List<String> requirements;
  final List<String> bonuses;
  final VoidCallback? onTapSpotName;
  final VoidCallback? onTapOrgName;
  final ShortBookingModel? booking;

  ParticipationStatusEnum _participationStatus(bool? approved) {
    if (approved == null) return ParticipationStatusEnum.processing;
    return approved == true ? ParticipationStatusEnum.accepted : ParticipationStatusEnum.declined;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            runSpacing: 8,
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              GestureDetector(onTap: onTapOrgName, child: Text(orgName, style: context.themes.main.texts.bodySmall)),
              const Interpunct(),
              GestureDetector(onTap: onTapSpotName, child: Text(spotName, style: context.themes.main.texts.bodySmall)),
            ],
          ),
          const SizedBox(height: 7),
          Text(title, style: context.themes.main.texts.h1),
          BlocBuilder<BookingEventBloc, CommonBlocState<BookingModel>>(
            builder: (context, state) {
              if (booking != null) {
                final status = _participationStatus(booking?.approved);
                return Column(children: [const SizedBox(height: 18), _ParticipationStatus(status: status)]);
              }

              if (state.hasValue) {
                final status = _participationStatus(state.value.approved);
                return Column(children: [const SizedBox(height: 18), _ParticipationStatus(status: status)]);
              }

              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 38),
          DateTimeInfo(address: address, date: startDate, startTime: startTime),
          const SizedBox(height: 32),
          Text(description, style: context.themes.main.texts.body),
          const SizedBox(height: 24),
          _OptionsBlock(title: 'От тебя ждем', options: requirements),
          const SizedBox(height: 24),
          _OptionsBlock(title: 'От тебя ждем', options: bonuses),
        ],
      ),
    );
  }
}

class _OptionsBlock extends StatelessWidget {
  const _OptionsBlock({required this.title, required this.options});

  final String title;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: context.themes.main.texts.body.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        for (final item in options) ...[
          Row(
            children: [
              const Interpunct(),
              const SizedBox(width: 12),
              Expanded(child: Text(item, style: context.themes.main.texts.body)),
            ],
          ),
        ],
      ],
    );
  }
}

enum ParticipationStatusEnum { processing, accepted, declined }

class _ParticipationStatus extends StatelessWidget {
  const _ParticipationStatus({this.status = ParticipationStatusEnum.processing});

  final ParticipationStatusEnum status;

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    final textStyles = context.themes.main.texts;

    final (textColor, icon, message) = switch (status) {
      ParticipationStatusEnum.processing => (
        colors.warning600,
        Assets.icons.processing.svg(),
        'Ваша заявка обрабатывается',
      ),
      ParticipationStatusEnum.accepted => (colors.success600, Assets.icons.success.svg(), 'Вы участвуете'),
      ParticipationStatusEnum.declined => (colors.error600, Assets.icons.error.svg(), 'Вы не допущены к участию'),
    };

    return Row(
      children: [
        icon,
        const SizedBox(width: 6),
        Expanded(child: Text(message, style: textStyles.body.copyWith(color: textColor))),
      ],
    );
  }
}

class _SignUpDone extends StatelessWidget {
  const _SignUpDone.success()
    : _icon = Icons.check_outlined,
      _title = 'Вы записаны!',
      _message = 'Ваша заявка отправлена\nна рассмотрение',
      _buttonTitle = 'Отлично!',
      _isSuccess = true;

  const _SignUpDone.error()
    : _icon = Icons.close_outlined,
      _title = 'Ошибка!',
      _message = 'Не удалось записаться на мероприятие, попробуйте позже',
      _buttonTitle = 'Блин...',
      _isSuccess = false;

  final IconData _icon;
  final String _title, _message, _buttonTitle;
  final bool _isSuccess;

  @override
  Widget build(BuildContext context) {
    final iconColor = _isSuccess ? context.themes.main.colors.success600 : context.themes.main.colors.error600;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
              child: Icon(_icon, color: context.themes.main.colors.inverse),
            ),
          ),
          const SizedBox(height: 12),
          Text(_title, style: context.themes.main.texts.h3),
          const SizedBox(height: 5),
          Text(_message, textAlign: TextAlign.center, style: context.themes.main.texts.body),
          const SizedBox(height: 36),
          AppButton.primary(onTap: () => Navigator.pop(context), title: _buttonTitle),
        ],
      ),
    );
  }
}

class _BookingButtonBuilder extends StatelessWidget {
  const _BookingButtonBuilder({required this.builder});

  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: builder.call(context)),
    );
  }
}

class _DeclineBookingModal extends StatelessWidget {
  const _DeclineBookingModal({required this.userId, required this.eventId, required this.bloc});

  final String eventId, userId;
  final BookingEventBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Builder(
        builder: (context) {
          return BlocListener<BookingEventBloc, BookingEventState>(
            listener: (_, state) {
              if (state.isError) {
                NotificationManager.of(context).showNotification(
                  notification: const AppNotification(message: 'Что-то пошло не так', status: NotificationStatus.error),
                );
              }
              if (state.isDone) {
                NotificationManager.of(context).showNotification(
                  notification: const AppNotification(
                    title: 'Вы успешно отписались',
                    status: NotificationStatus.success,
                  ),
                );
              }

              Navigator.pop(context);
            },
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Вы уверены?', style: context.themes.main.texts.h3),
                    const SizedBox(height: 18),
                    Text(
                      'Текущая заявка на участие будет отменена. Вы сможете подать ее снова в любое время.',
                      style: context.themes.main.texts.body,
                    ),
                    const SizedBox(height: 36),
                    AppButton.warning(
                      title: 'Отменить завявку',
                      onTap:
                          () => context.read<BookingEventBloc>().add(RemoveBookEvent(eventId: eventId, userId: userId)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
