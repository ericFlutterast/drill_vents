import 'package:drill_events/app/blocs/detail_event/bloc.dart';
import 'package:drill_events/app/blocs/detail_event/events.dart';
import 'package:drill_events/app/features/event/widgets/event_description_tile.dart';
import 'package:drill_events/app/features/event/widgets/invite_request_to_event_modal.dart';
import 'package:drill_events/app/features/widgets/app_back_button.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/app_company_logo.dart';
import 'package:drill_events/app/features/widgets/interpunct.dart';
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
    return BlocProvider<DetailEventBloc>(
      create:
          (_) => DetailEventBloc(
            context.dependencies.fastCache,
            context.dependencies.repository,
            context.dependencies.logger,
          )..add(FetchDetailEvent(id: '')),
      child: const EventScreen(),
    );
  }

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> with SingleTickerProviderStateMixin, AnimationForBackButton {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.themes.main.colors.inverse,
      body: SafeArea(
        top: false,
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
                      Text('The Future of Work. How technology is reshaping', style: context.themes.main.texts.h1),

                      if (false) ...[
                        const SizedBox(height: 18),
                        const _ParticipationStatus(status: ParticipationStatusEnum.declined),
                      ],
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AppButton(
                    title: 'Записаться',
                    onTap: () async {
                      final result = await Navigator.push<bool?>(
                        context,
                        AppModalBottomSheetPage<bool>(
                          useSafeArea: true,
                          child: JoinEventModal.bloc(
                            context,
                            conditionsForParticipation: [
                              'Уровень английского B1 и выше',
                              'Уровень китайского 99 и выше',
                              'Японское гражданство',
                              'Звание глобала и 8к ммр в доте',
                            ],
                          ),
                        ).createRoute(context),
                      );

                      if (result == true) {
                        _scrollController.animateTo(
                          0.0,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn,
                        );
                      }
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
                position: Tween<Offset>(begin: Offset.zero, end: const Offset(-50, 0)).animate(_animationController),
                child: AppBackButton(onTap: () => Navigator.pop(context)),
              ),
            ),
          ],
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

enum ParticipationStatusEnum {
  processing('Ваша заявка обрабатывается'),
  accepted('Вы участвуете'),
  declined('Вы не допущены к участию');

  const ParticipationStatusEnum(this.message);

  final String message;
}

class _ParticipationStatus extends StatelessWidget {
  const _ParticipationStatus({this.status = ParticipationStatusEnum.processing});

  final ParticipationStatusEnum status;

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    final textStyles = context.themes.main.texts;

    final (textColor, icon) = switch (status) {
      // Убери поля из енума и текст тут возвращай, когда интернационализацию подрубим все равно все текста в контексте будут
      ParticipationStatusEnum.processing => (colors.warning600, Assets.icons.processing.svg()),
      ParticipationStatusEnum.accepted => (colors.success600, Assets.icons.success.svg()),
      ParticipationStatusEnum.declined => (colors.error600, Assets.icons.error.svg()),
    };

    return Row(
      children: [
        icon,
        const SizedBox(width: 6),
        Expanded(child: Text(status.message, style: textStyles.body.copyWith(color: textColor))),
      ],
    );
  }
}
