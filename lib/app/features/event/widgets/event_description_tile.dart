import 'package:drill_events/app/features/widgets/interpunct.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

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
