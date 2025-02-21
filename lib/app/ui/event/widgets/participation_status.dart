import 'package:drill_events/app/generated/assets.gen.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

enum ParticipationStatusEnum {
  processing('Ваша заявка обрабатывается'),
  accepted('Вы участвуете'),
  declined('Вы не допущены к участию');

  const ParticipationStatusEnum(this.message);

  final String message;
}

class ParticipationStatus extends StatelessWidget {
  const ParticipationStatus({super.key, this.status = ParticipationStatusEnum.processing});

  final ParticipationStatusEnum status;

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    final textStyles = context.themes.main.texts;

    final (textColor, icon) = switch (status) {
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
