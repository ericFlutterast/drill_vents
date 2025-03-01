import 'package:drill_events/app/blocs/auth/bloc.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/blocs/detail_event/bloc.dart';
import 'package:drill_events/app/blocs/detail_event/events.dart';
import 'package:drill_events/app/blocs/registration/bloc.dart';
import 'package:drill_events/app/blocs/registration/events.dart';
import 'package:drill_events/app/blocs/sign_up_to_event/bloc.dart';
import 'package:drill_events/app/blocs/sign_up_to_event/events.dart';
import 'package:drill_events/app/features/event/widgets/creating_entry_for_event_modal.dart';
import 'package:drill_events/app/features/event/widgets/event_description_tile.dart';
import 'package:drill_events/app/features/event/widgets/join_event_modal.dart';
import 'package:drill_events/app/features/event/widgets/participation_notification.dart';
import 'package:drill_events/app/features/widgets/app_back_button.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/app_company_logo.dart';
import 'package:drill_events/app/features/widgets/interpunct.dart';
import 'package:drill_events/app/features/widgets/notification_manager.dart';
import 'package:drill_events/app/generated/assets.gen.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/navigation/modal_bottom_sheet.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//TODO:
const _items = ['Завтра', 'Surf x Post', 'English club'];

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
                context.dependencies.repository,
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

class _EventScreenState extends State<EventScreen> with SingleTickerProviderStateMixin, AnimationForBackButton {
  bool _isRegistrationUserFlow = false;
  final _loadingBottomSheetName = 'Loading';

  late final ScrollController _scrollController = ScrollController();
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
    reverseDuration: const Duration(milliseconds: 400),
  );

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      buttonVisibility(animationController: _animationController, scrollController: _scrollController);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showErrorNotification(String message) {
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

  void _signUpToEventBlocListener(BuildContext context, CommonBlocState<String> state) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.themes.main.colors.inverse,
      body: SafeArea(
        top: false,
        child: BlocListener<RegistrationBloc, CommonBlocState>(
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
            child: BlocListener<SignUpToEventBloc, CommonBlocState<String>>(
              listener: _signUpToEventBlocListener,
              child: Stack(
                children: [
                  ListView(
                    controller: _scrollController,
                    children: [
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(padding: EdgeInsets.only(right: 20), child: AppCompanyLogo()),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              runSpacing: 8,
                              spacing: 12,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                for (final (i, item) in _items.indexed) ...[
                                  Text(item, style: context.themes.main.texts.bodySmall),
                                  if (i != _items.length - 1) const Interpunct(),
                                ],
                              ],
                            ),
                            const SizedBox(height: 7),
                            Text(
                              'The Future of Work. How technology is reshaping',
                              style: context.themes.main.texts.h1,
                            ),
                            BlocBuilder<SignUpToEventBloc, CommonBlocState<String>>(
                              builder: (context, state) {
                                if (state.hasValue) {
                                  return const Column(
                                    children: [
                                      SizedBox(height: 18),
                                      _ParticipationStatus(status: ParticipationStatusEnum.processing),
                                    ],
                                  );
                                }

                                return const SizedBox.shrink();
                              },
                            ),
                            const SizedBox(height: 38),
                            const _DateTimeInfo(),
                            const SizedBox(height: 32),
                            Text(
                              'Приглашаем на английский клуб! Давайте прокачаем свои знания по английскому 😉',
                              style: context.themes.main.texts.body,
                            ),
                            const SizedBox(height: 24),
                            const EventDescriptionTile(
                              title: 'От тебя ждем',
                              descriptionRows: [
                                'Уровень английского B1 и выше',
                                'Уровень китайского 99 и выше',
                                'Японское гражданство',
                                'Звание глобала и 8к ммр в доте',
                              ],
                            ),
                            const SizedBox(height: 24),
                            const EventDescriptionTile(
                              title: 'С нас',
                              descriptionRows: [
                                'Стол и стул (или бутылка)',
                                'Участникам скидка 10% на напитки собственного приготовления 😉',
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 42),
                      if (!context.read<AuthBloc>().state.hasValue)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: AppButton(
                            title: _isRegistrationUserFlow ? 'Идет запись' : 'Записаться',
                            isLoading: _isRegistrationUserFlow,
                            onTap: _startRegistration,
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: BlocBuilder<SignUpToEventBloc, CommonBlocState<String>>(
                            builder: (context, state) {
                              if (state.isPending) {
                                return const AppButton(title: 'Идет запись', isLoading: true);
                              }
                              if (state.isDone) {
                                return AppButton(
                                  title: 'Отменить завявку',
                                  backgroundColor: context.themes.main.colors.warning100,
                                  titleStyle: context.themes.main.texts.body.copyWith(
                                    color: context.themes.main.colors.warning600,
                                  ),
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        const AppModalBottomSheetPage(
                                          child: _DeclineSignUpModal(),
                                        ).createRoute(context),
                                      ),
                                );
                              }

                              return AppButton(
                                title: 'Записаться',
                                onTap: () {
                                  final email = context.read<AuthBloc>().state.value.email;
                                  context.read<SignUpToEventBloc>().add(SignUpEvent(email: email));
                                },
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 25),
                    ],
                  ),
                  Positioned(
                    top: 5 + MediaQuery.sizeOf(context).height * 0.1,
                    left: 20,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(-50, 0),
                      ).animate(_animationController),
                      child: AppBackButton(onTap: () => Navigator.pop(context)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
          AppButton(onTap: () => Navigator.pop(context), title: _buttonTitle),
        ],
      ),
    );
  }
}

class _DeclineSignUpModal extends StatelessWidget {
  const _DeclineSignUpModal();

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
          AppButton(
            title: 'Отменить завявку',
            titleStyle: context.themes.main.texts.body.copyWith(color: context.themes.main.colors.warning600),
            backgroundColor: context.themes.main.colors.warning100,
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
