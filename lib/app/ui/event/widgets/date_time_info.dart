import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

class DateTimeInfo extends StatelessWidget {
  const DateTimeInfo({super.key});

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
            color: context.themes.main.colors.greyLight,
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
