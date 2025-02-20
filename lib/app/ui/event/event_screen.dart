import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/app/ui/event/widgets/event_description_tile.dart';
import 'package:drill_events/app/ui/widgets/app_back_button.dart';
import 'package:drill_events/app/ui/widgets/app_button.dart';
import 'package:drill_events/app/ui/widgets/app_company_logo.dart';
import 'package:drill_events/app/ui/widgets/interpunct.dart';
import 'package:drill_events/common/navigation/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';

import 'widgets/date_time_info.dart';
import 'widgets/invite_request_to_event_modal.dart';

//TODO:
const _items = ['Завтра', 'Surf x Post', 'English club'];

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> with SingleTickerProviderStateMixin, AnimationForBackButton {
  late final ScrollController _scrollController = ScrollController();
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
    reverseDuration: const Duration(milliseconds: 1200),
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
    super.dispose();
    _scrollController.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.themes.main.colors.background,
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
                      const SizedBox(height: 38),
                      const DateTimeInfo(),
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
                      const SizedBox(height: 42),
                      AppButton(
                        title: 'Записаться',
                        onTap:
                            () => Navigator.push(
                              context,
                              const AppModalBottomSheetPage(
                                useSafeArea: true,
                                child: InviteRequestToEventModal(
                                  conditionsForParticipation: [
                                    'Уровень английского B1 и выше',
                                    'Уровень китайского 99 и выше',
                                    'Японское гражданство',
                                    'Звание глобала и 8к ммр в доте',
                                  ],
                                ),
                              ).createRoute(context),
                            ),
                      ),
                    ],
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
