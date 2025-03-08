import 'package:drill_events/app/blocs/auth/bloc.dart';
import 'package:drill_events/app/blocs/booking_event/bloc.dart';
import 'package:drill_events/app/blocs/booking_event/events.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/blocs/detail_event/bloc.dart';
import 'package:drill_events/app/blocs/detail_event/events.dart';
import 'package:drill_events/app/blocs/registration/bloc.dart';
import 'package:drill_events/app/blocs/registration/events.dart';
import 'package:drill_events/app/features/event/widgets/creating_entry_for_event_modal.dart';
import 'package:drill_events/app/features/event/widgets/join_event_modal.dart';
import 'package:drill_events/app/features/event/widgets/participation_notification.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
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

class EventScreenArgs {
  EventScreenArgs(this.eventId);

  final String eventId;
}

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  static Widget bloc(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //TODO: В di
        BlocProvider<DetailEventBloc>(
          create:
              (_) => DetailEventBloc(
                context.dependencies.fastCache,
                context.dependencies.backendApi,
                context.dependencies.logger,
              )..add(FetchDetailEvent(id: '')),
        ),
        BlocProvider(create: (_) => context.dependencies.signUpToEventBloc),
        BlocProvider(create: (_) => context.dependencies.registrationBloc),
      ],
      child: const EventScreen(),
    );
  }

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool _isAuthUser = false;
  bool _isRegistrationUserFlow = false;
  final _loadingBottomSheetName = 'Loading';

  late final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _isAuthUser = context.read<AuthBloc>().state.hasValue;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showErrorNotification(String message) {
    //TODO: Этого не должно тут быть. Это зона ответственности NotificationManager а не этого скрина
    //TODO: На рассмотрении
    NotificationManager.of(context).showNotification(
      notification: ParticipationNotification(status: ParticipationNotificationStatus.error, message: message),
    );
    setState(() => _isRegistrationUserFlow = false);
    Navigator.popUntil(context, (route) => route.settings.name != _loadingBottomSheetName);
  }

  void _startRegistration() async {
    final userData = await _promptUserData();

    if (userData case [String email, String password]) {
      _startUserRegistrationChain(email, password);
    }
  }

  Future<List<String>> _promptUserData() async {
    return await Navigator.push<List<String>>(
          context,
          const AppModalBottomSheetPage<List<String>>(
            useSafeArea: true,
            child: JoinEventModal(
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

  void _startUserRegistrationChain(String email, String password) {
    if (mounted) {
      setState(() => _isRegistrationUserFlow = true);
      context.read<RegistrationBloc>().add(CreateUserEvent(email: email, password: password, publishToPipe: true));
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
    setState(() => _isRegistrationUserFlow = false);
  }

  void _bookToEvent() {
    final email = context.read<AuthBloc>().state.value.email;
    context.read<BookingEventBloc>().add(BookToEvent(email: email));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.themes.main.colors.inverse,
      body: BlocListener<RegistrationBloc, CommonBlocState>(
        listener: (_, state) {
          if (state.isError) {
            _showErrorNotification(state.errorMessage.toString());
          }
        },
        child: BlocListener<AuthBloc, CommonBlocState>(
          listener: (context, state) {
            if (state.isError) {
              _showErrorNotification(state.errorMessage.toString());
            }
          },
          child: BlocListener<BookingEventBloc, CommonBlocState<BookingModel>>(
            listener: _signUpToEventBlocListener,
            child: Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    const SliverPadding(padding: EdgeInsets.only(top: 180)),
                    SliverToBoxAdapter(
                      child: _ContentSection(
                        // TODO:
                        onTapOrgName: () => context.openOrgScreen("7fdb5b3d-9de4-4dbb-a862-1a430feeb7fa"),
                        // TODO:
                        onTapSpotName: () => context.openSpotScreen("2985f696-0ee6-4e2a-9ff6-e95b758526fc"),
                        title: 'The Future of Work. How technology is reshaping',
                        description: 'Приглашаем на английский клуб! Давайте прокачаем свои знания по английскому 😉',
                        orgName: 'Surf',
                        spotName: 'Surf x Post',
                        requirements: [
                          'Уровень английского B1 и выше',
                          'Уровень китайского 99 и выше',
                          'Японское гражданство',
                          'Звание глобала и 8к ммр в доте',
                        ],
                        bonuses: [
                          'Стол и стул (или бутылка)',
                          'Участникам скидка 10% на напитки собственного приготовления 😉',
                        ],
                      ),
                    ),
                    const SliverPadding(padding: EdgeInsets.only(top: 42)),
                    if (!_isAuthUser)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child:
                              _isRegistrationUserFlow
                                  ? const AppButton.loading(title: 'Идет запись')
                                  : AppButton.primary(title: 'Записаться', onTap: _startRegistration),
                        ),
                      )
                    else
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: BlocBuilder<BookingEventBloc, CommonBlocState<BookingModel>>(
                            builder: (context, state) {
                              if (state.isPending) {
                                return const AppButton.loading(title: 'Идет запись');
                              }
                              if (state.isDone) {
                                return AppButton.warning(
                                  title: 'Отменить завявку',
                                  onTap: () => context.openBottomSheet(const _DeclineBookingModal()),
                                );
                              }
                              return AppButton.primary(title: 'Записаться', onTap: _bookToEvent);
                            },
                          ),
                        ),
                      ),
                    const SliverPadding(padding: EdgeInsets.only(top: 25)),
                  ],
                ),
                PositionedScreenHeader(
                  controller: _scrollController,
                  onTapLogo: () => context.openOrgScreen("7fdb5b3d-9de4-4dbb-a862-1a430feeb7fa"),
                ),
              ],
            ),
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
    this.onTapOrgName,
    this.onTapSpotName,
  });

  final String title;
  final String description;
  final String orgName;
  final String spotName;
  final List<String> requirements;
  final List<String> bonuses;
  final VoidCallback? onTapSpotName;
  final VoidCallback? onTapOrgName;

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
              if (!state.hasValue) const SizedBox.shrink();

              return const Column(
                children: [SizedBox(height: 18), _ParticipationStatus(status: ParticipationStatusEnum.processing)],
              );
            },
          ),
          const SizedBox(height: 38),
          const _DateTimeInfo(),
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

class _DateTimeInfo extends StatelessWidget {
  const _DateTimeInfo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('16 февраля', style: context.themes.main.texts.h3),
            const SizedBox(height: 6),
            Text('Краснодар, Постовая 55', style: context.themes.main.texts.bodySmall),
          ],
        ),
        const Spacer(),
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.themes.main.colors.background,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
            child: Text('19:00', style: context.themes.main.texts.h3),
          ),
        ),
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

class _DeclineBookingModal extends StatelessWidget {
  const _DeclineBookingModal();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            onTap: () {
              //TODO: запрос отмены заявки
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
