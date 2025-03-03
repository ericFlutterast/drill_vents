import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({super.key});

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTime? _selectDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PromptDatePicker(
          selectDate: _selectDate != null ? DateFormat('dd.MM.yyyy').format(_selectDate!) : '',
          onDateTimeChanged: (date) => setState(() => _selectDate = date),
        ),
        const SizedBox(height: 12),
        _PromptTime(
          onSelected: (from, to) {
            print('${from.toString()} ${to.toString()}');
          },
        ),
      ],
    );
  }
}

class _PromptDatePicker extends StatelessWidget {
  const _PromptDatePicker({this.selectDate = '', required this.onDateTimeChanged});

  final String selectDate;
  final Function(DateTime date) onDateTimeChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    final texts = context.themes.main.texts;

    final borderRadius = const BorderRadius.all(Radius.circular(50));

    return InkWell(
      borderRadius: borderRadius,
      onTap: () => context.openBottomSheet(_DatePickerModal(onDateTimeChanged: onDateTimeChanged)),
      child: Ink(
        decoration: BoxDecoration(color: colors.background, borderRadius: borderRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                selectDate.isEmpty ? '12.01.1970' : selectDate,
                style: texts.body.copyWith(color: selectDate.isNotEmpty ? colors.primary : colors.secondary),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.calendar_month_outlined, color: Color(0xFFD9D9D9)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DatePickerModal extends StatelessWidget {
  const _DatePickerModal({required this.onDateTimeChanged});

  final void Function(DateTime) onDateTimeChanged;

  @override
  Widget build(BuildContext context) {
    final dateNow = DateTime.now();

    //TODO: Добавить материал DatePicker
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.4,
      child: CupertinoDatePicker(
        initialDateTime: dateNow,
        minimumYear: dateNow.year,
        maximumYear: dateNow.year,
        maximumDate: DateTime(dateNow.year, dateNow.month + 6),
        onDateTimeChanged: onDateTimeChanged,
        mode: CupertinoDatePickerMode.date,
      ),
    );
  }
}

class _PromptTime extends StatefulWidget {
  const _PromptTime({required this.onSelected});

  final Function(DateTime from, DateTime to) onSelected;

  @override
  State<_PromptTime> createState() => _PromptTimeState();
}

class _PromptTimeState extends State<_PromptTime> {
  DateTime? from;
  DateTime? to;

  void _selectSecondValue(DateTime time) {
    setState(() => to = time);
    if (from != null && to != null) {
      widget.onSelected(from!, to!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleFrom = from != null ? DateFormat('HH:mm').format(from!) : null;
    final titleTo = to != null ? DateFormat('HH:mm').format(to!) : null;

    return Row(
      children: [
        Expanded(
          child: _PromptTimeItem(
            title: titleFrom,
            hintText: '12:00',
            onDateTimeChanged: (time) => setState(() => from = time),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: _PromptTimeItem(title: titleTo, hintText: '13:00', onDateTimeChanged: _selectSecondValue)),
      ],
    );
  }
}

class _PromptTimeItem extends StatelessWidget {
  const _PromptTimeItem({this.title, required this.hintText, required this.onDateTimeChanged});

  final String hintText;
  final String? title;
  final void Function(DateTime time) onDateTimeChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    final texts = context.themes.main.texts;

    final borderRadius = const BorderRadius.all(Radius.circular(50));
    return InkWell(
      //TODO: добавить поддержку материал дизайна
      onTap: () => context.openBottomSheet(_TimePickerModal(onDateTimeChanged: onDateTimeChanged)),
      borderRadius: borderRadius,
      child: Ink(
        decoration: BoxDecoration(color: colors.background, borderRadius: borderRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text(
              title ?? hintText,
              style: texts.body.copyWith(color: title != null ? colors.primary : colors.secondary),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimePickerModal extends StatelessWidget {
  const _TimePickerModal({required this.onDateTimeChanged});

  final void Function(DateTime time) onDateTimeChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.4,
      child: CupertinoDatePicker(
        onDateTimeChanged: onDateTimeChanged,
        mode: CupertinoDatePickerMode.time,
        initialDateTime: DateTime.now(),
        use24hFormat: true,
      ),
    );
  }
}
