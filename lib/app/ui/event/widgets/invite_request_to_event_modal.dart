import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/app/ui/event/widgets/event_description_tile.dart';
import 'package:drill_events/app/ui/widgets/app_button.dart';
import 'package:drill_events/app/ui/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class InviteRequestToEventModal extends StatelessWidget {
  const InviteRequestToEventModal({super.key, required this.conditionsForParticipation});

  final Iterable<String> conditionsForParticipation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          EventDescriptionTile(
            title: 'Условия',
            titleStyle: context.themes.main.texts.h3,
            descriptionRows: conditionsForParticipation,
          ),
          const SizedBox(height: 36),
          const AppTextField(hintText: 'Email'),
          const SizedBox(height: 36),
          AppButton(
            title: 'Отправить заявку',
            onTap: () {
              //TODO:
            },
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
        ],
      ),
    );
  }
}
