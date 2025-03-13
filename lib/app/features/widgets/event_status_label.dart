import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/app/themes/colors_theme.dart';
import 'package:flutter/material.dart';

enum EventStatus { processing, success, decline }

class EventStatusLabel extends StatelessWidget {
  const EventStatusLabel({super.key, required this.status});

  final EventStatus status;

  String get _title => switch (status) {
    EventStatus.processing => 'На рассмотрении',
    EventStatus.success => 'Одобрено',
    EventStatus.decline => 'Отказано',
  };

  Color _backgroundColor(AppColors colors) => switch (status) {
    EventStatus.processing => colors.warning100,
    EventStatus.success => colors.success100,
    EventStatus.decline => colors.error100,
  };

  Color _titleColor(AppColors colors) => switch (status) {
    EventStatus.processing => colors.warning600,
    EventStatus.success => colors.success600,
    EventStatus.decline => colors.error600,
  };

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;
    final colors = context.themes.main.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: _backgroundColor(colors),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text(_title, style: texts.caption.copyWith(color: _titleColor(colors))),
      ),
    );
  }
}
