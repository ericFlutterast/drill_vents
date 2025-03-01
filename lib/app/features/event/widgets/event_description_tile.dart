import 'package:drill_events/app/features/widgets/interpunct.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

// Тут чисто пасхалку оставлю. Ты попытался переиспользовать этот виджет для модалки и для тела - не нужно, если
// присмотришься - они совершенно разные, хоть и похожи. Самое главное - у них разные контексты, если поменяется
// дизайн в модалке тебе придется копаться в говне. Лучше писать максимально тупой код, чем пытаться переиспользовать
// компоненты везде. Принцип закрытости открытости, это не совсем про это, но он тут в тему. Типо ты пишешь код для
// одного кейса конкретного, когда ты пытаешься залезть в него и переписать, чтобы он мог использовать в друго,
// в третьем, четвертом - это плохой дизайн. (Я тоже страдал от этого, но ничего хорошего в этом нет)
class EventDescriptionTile extends StatelessWidget {
  const EventDescriptionTile({
    super.key,
    required this.title,
    required this.descriptionRows,
    this.titleStyle,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Iterable<String> descriptionRows;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final textStyles = context.themes.main.texts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (subtitle != null) ...[
          Text(title, style: titleStyle ?? textStyles.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          Text(subtitle ?? '', style: textStyles.body),
          const SizedBox(height: 8),
        ] else ...[
          Text(title, style: titleStyle ?? textStyles.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
        ],
        for (final (i, item) in descriptionRows.indexed) ...[
          Row(
            children: [
              const Interpunct(),
              const SizedBox(width: 12),
              Expanded(child: Text(item, style: textStyles.body)),
            ],
          ),
          if (i != descriptionRows.length - 1) const SizedBox(height: 4),
        ],
      ],
    );
  }
}
