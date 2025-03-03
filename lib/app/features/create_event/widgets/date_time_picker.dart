import 'package:drill_events/app/features/create_event/widgets/create_event_inherited_view_model.dart';
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
  String? _selectDate;

  late NewEventState _eventState;

  @override
  void initState() {
    super.initState();
    _eventState = NewEventInheritedViewModel.of(context);
  }

  void _onDateSelect(DateTime date) {
    final String selectDate = DateFormat('yyyy-MM-dd').format(date);
    setState(() => _selectDate = selectDate);
    _eventState.model = _eventState.model.copyWith(startDate: selectDate);
  }

  void _onSelectTime(String startTime, String endTime) {
    _eventState.model = _eventState.model.copyWith(startTime: startTime, endTime: endTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PromptDatePicker(selectDate: _selectDate ?? '', onDateTimeChanged: _onDateSelect),
        const SizedBox(height: 12),
        _PromptTime(onSelected: _onSelectTime),
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

  final Function(String from, String to) onSelected;

  @override
  State<_PromptTime> createState() => _PromptTimeState();
}

class _PromptTimeState extends State<_PromptTime> {
  DateTime? start;
  DateTime? end;

  void _selectSecondValue(DateTime time) {
    setState(() => end = time);
    if (start != null && end != null) {
      final startFormatted = DateFormat('HH:mm:ss').format(start!);
      final endFormatted = DateFormat('HH:mm:ss').format(end!);
      widget.onSelected(startFormatted, endFormatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleStart = start != null ? DateFormat('HH:mm').format(start!) : null;
    final titleEnd = end != null ? DateFormat('HH:mm').format(end!) : null;

    return Row(
      children: [
        Expanded(
          child: _PromptTimeItem(
            title: titleStart,
            hintText: '12:00',
            onDateTimeChanged: (time) => setState(() => start = time),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: _PromptTimeItem(title: titleEnd, hintText: '13:00', onDateTimeChanged: _selectSecondValue)),
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
