import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeInfo extends StatelessWidget {
  const DateTimeInfo({super.key, required this.address, required this.startTime, required this.date});

  final String address;
  final String date;
  final String startTime;

  String formattedTime(String time) {
    final startTime = DateTime.tryParse(time);
    return startTime != null ? DateFormat('HH:mm').format(startTime) : '';
  }

  String formattedDate(String date) {
    final startDate = DateTime.tryParse(date);
    return startDate != null ? DateFormat('dd MMMM').format(startDate) : '';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formattedDate(date), style: context.themes.main.texts.h3),
            const SizedBox(height: 6),
            Text(address, style: context.themes.main.texts.bodySmall), //'Краснодар, Постовая 55'
          ],
        ),
        const Spacer(),
        if (startTime.isNotEmpty)
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.themes.main.colors.background,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
              child: Text(formattedTime(startTime), style: context.themes.main.texts.h3),
            ),
          ),
      ],
    );
  }
}
