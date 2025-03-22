import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

class CreatingEntryForEventModal extends StatelessWidget {
  const CreatingEntryForEventModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(color: context.themes.main.colors.warning600, shape: BoxShape.circle),
                child: Icon(Icons.access_time_rounded, color: context.themes.main.colors.inverse),
              ),
            ),
            const SizedBox(height: 12),
            Text('Записываемся...', style: context.themes.main.texts.h3),
          ],
        ),
      ),
    );
  }
}
