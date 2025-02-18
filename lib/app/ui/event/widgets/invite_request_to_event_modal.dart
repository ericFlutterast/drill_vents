import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/app/ui/widgets/app_bottom_sheet.dart';
import 'package:drill_events/app/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';

class InviteRequestToEventModal extends StatelessWidget {
  const InviteRequestToEventModal({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Внимание!', style: context.themes.main.texts.h2),
            const SizedBox(height: 10),
            Text('Рекомендации к ивенту:', style: context.themes.main.texts.h3),
            for (int i = 0; i < 3; i++) Text('- Уровень английского B1 и выше', style: context.themes.main.texts.body),
            const Spacer(),
            AppButton(
              title: 'Отправить заявку',
              onTap: () {
                //TODO:
              },
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
          ],
        ),
      ),
    );
  }
}
