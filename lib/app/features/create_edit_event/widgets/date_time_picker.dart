import 'package:drill_events/app/features/create_edit_event/validators/event_validators.dart';
import 'package:drill_events/app/features/widgets/validation_builder.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({super.key, required this.validator});

  final DateTimeValidator validator;

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  String? _selectDate;

  @override
  void initState() {
    super.initState();
    if (widget.validator.value?.startDate case DateTime startDate) {
      _selectDate = DateFormat('dd-MM-yyyy').format(startDate);
    }
  }

  void _onDateSelect(DateTime date) {
    final String selectDate = DateFormat('dd-MM-yyyy').format(date);
    setState(() => _selectDate = selectDate);
    widget.validator.value?.startDate = date;
  }

  void _onSelectTime(DateTime? startTime, DateTime? endTime) {
    widget.validator.value?.startTime = startTime;
    widget.validator.value?.endTime = endTime;
  }

  @override
  Widget build(BuildContext context) {
    return ValidationBuilder(
      validator: widget.validator,
      builder: (context, value, _) {
        return Column(
          children: [
            _PromptDatePicker(selectDate: _selectDate ?? '', onDateTimeChanged: _onDateSelect),
            const SizedBox(height: 12),
            _PromptTime(
              initStartValue: widget.validator.value?.startTime,
              initEndValue: widget.validator.value?.endTime,
              onSelected: _onSelectTime,
            ),
          ],
        );
      },
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
  const _PromptTime({required this.onSelected, this.initEndValue, this.initStartValue});

  final DateTime? initStartValue, initEndValue;
  final Function(DateTime? from, DateTime? to) onSelected;

  @override
  State<_PromptTime> createState() => _PromptTimeState();
}

class _PromptTimeState extends State<_PromptTime> {
  DateTime? start;
  DateTime? end;

  @override
  void initState() {
    super.initState();
    start = widget.initStartValue;
    end = widget.initEndValue;
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
            onDateTimeChanged: (time) {
              setState(() => start = time);
              widget.onSelected(time, end);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PromptTimeItem(
            title: titleEnd,
            hintText: '13:00',
            onDateTimeChanged: (time) {
              setState(() => end = time);
              widget.onSelected(start, end);
            },
          ),
        ),
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
