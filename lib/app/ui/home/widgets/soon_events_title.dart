import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

class SoonEventsTitle extends StatelessWidget {
  const SoonEventsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 45, 28, 28),
        child: Text('Ближайшие события', style: context.themes.main.texts.body),
      ),
    );
  }
}
