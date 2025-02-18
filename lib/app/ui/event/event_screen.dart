import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/app/ui/widgets/app_back_button.dart';
import 'package:drill_events/app/ui/widgets/app_button.dart';
import 'package:drill_events/app/ui/widgets/app_company_logo.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 28),
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
                const Align(alignment: Alignment.centerRight, child: AppCompanyLogo()),
                const SizedBox(height: 67),
                Wrap(
                  runSpacing: 8,
                  spacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (final (i, item) in _items.indexed) ...[
                      Text(item, style: context.themes.main.texts.bodySmall),
                      if (i != _items.length - 1)
                        SizedBox.square(
                          dimension: 5,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: context.themes.main.colors.greyDark,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text('The Future of Work. How technology is reshaping', style: context.themes.main.texts.h1),
                const SizedBox(height: 54),
                const DateTimeInfo(),
                const SizedBox(height: 40),
                Text(
                  'Приглашаем на английский клуб! Давайте прокачаем свои знания по английскому 😉',
                  style: context.themes.main.texts.body,
                ),
                const SizedBox(height: 17),
                Text('Уровень B1 и выше', style: context.themes.main.texts.body),
                const SizedBox(height: 46),
                Text('Участие — напиток', style: context.themes.main.texts.bodySmall),
                Text(
                  'Участникам скидка 10% на напитки собственного приготовления 😉',
                  style: context.themes.main.texts.bodySmall,
                ),
                const SizedBox(height: 18),
                AppButton(
                  title: 'Записаться',
                  onTap:
                      () => Navigator.push(
                        context,
                        const AppModalBottomSheetPage(child: InviteRequestToEventModal()).createRoute(context),
                      ),
                ),
                const SizedBox(height: 25),
              ],
            ),
            Positioned(
              top: 5 + MediaQuery.sizeOf(context).height * 0.1,
              left: 15,
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
