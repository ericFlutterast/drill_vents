import 'package:cached_network_image/cached_network_image.dart';
import 'package:drill_events/app/features/widgets/app_back_button.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/app_text_field.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  late final _scrollController = ScrollController();

  DateTime? _selectDate;
  int? _selectedSpotIndex;

  final Map<ValueKey, TextEditingController> _expectationFromMembers = {const ValueKey('1'): TextEditingController()};
  final Map<ValueKey, TextEditingController> _organizationWillProvide = {const ValueKey('2'): TextEditingController()};

  void _selectSpot(int index) {
    if (index == _selectedSpotIndex) {
      setState(() => _selectedSpotIndex = null);
      return;
    }
    setState(() => _selectedSpotIndex = index);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (final entry in _expectationFromMembers.entries) {
      entry.value.dispose();
    }
    for (final entry in _organizationWillProvide.entries) {
      entry.value.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    final texts = context.themes.main.texts;

    return Scaffold(
      backgroundColor: colors.inverse,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 180, 20, 25),
                sliver: SliverList.list(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                      child: Text('Новое событие', style: texts.h1),
                    ),
                    const SizedBox(height: 28),
                    //TODO: пик дату и пик время нужно объеденить в один виджет
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
                    const SizedBox(height: 32),
                    const AppTextField(hintText: 'Имя', maxLines: 1),
                    const SizedBox(height: 12),
                    AppTextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Описание',
                        hintStyle: context.themes.main.texts.body.copyWith(color: context.themes.main.colors.secondary),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _CountOfSeats(),
                    const SizedBox(height: 24),
                    //TODO: Нужна какая то обертка
                    Text('Ожидания от участников', style: texts.body.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    for (final (index, entry) in _expectationFromMembers.entries.indexed) ...[
                      _Options(
                        key: entry.key,
                        controller: entry.value,
                        onAdd:
                            () => setState(
                              () => _expectationFromMembers[ValueKey(entry.value.text)] = TextEditingController(),
                            ),
                        onDelete: () => setState(() => _expectationFromMembers.remove(entry.key)),
                      ),
                      if (index != _expectationFromMembers.length - 1) const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 24),
                    Text('Мы обеспечим', style: texts.body.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    for (final (index, entry) in _organizationWillProvide.entries.indexed) ...[
                      _Options(
                        key: entry.key,
                        controller: entry.value,
                        onAdd:
                            () => setState(
                              () => _expectationFromMembers[ValueKey(entry.value.text)] = TextEditingController(),
                            ),
                        onDelete: () => setState(() => _expectationFromMembers.remove(entry.key)),
                      ),
                      if (index != _expectationFromMembers.length - 1) const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 32),
                    Text('Опубликовать в', style: texts.body.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    for (final (index, item) in [1, 2, 3, 4].indexed) ...[
                      _Spot(onSelect: () => _selectSpot(index), isSelect: _selectedSpotIndex == index),
                      if (index != 3) const SizedBox(height: 20),
                    ],
                    const SizedBox(height: 24),
                    AppButton.primary(title: 'Опубликовать', onTap: () {}),
                  ],
                ),
              ),
            ],
          ),
          _PositionedCreateEventHeader(scrollController: _scrollController),
        ],
      ),
    );
  }
}

class _PositionedCreateEventHeader extends StatefulWidget {
  const _PositionedCreateEventHeader({required this.scrollController});

  final ScrollController scrollController;

  @override
  State<_PositionedCreateEventHeader> createState() => _CreateEventHeaderState();
}

class _CreateEventHeaderState extends State<_PositionedCreateEventHeader> with SingleTickerProviderStateMixin {
  final _scrollThreshold = 60;
  late final AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    final curvedAnimation = CurvedAnimation(parent: _animationController, curve: Curves.fastEaseInToSlowEaseOut);
    _animation = Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-2, 0)).animate(curvedAnimation);

    widget.scrollController.addListener(_runAnimation);
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.scrollController.removeListener(_runAnimation);
    super.dispose();
  }

  void _runAnimation() {
    if (_animationController.status.isAnimating) return;

    // It's safe, since this method is called only if controller is passed
    final position = widget.scrollController.position;
    final (offset, direction) = (position.pixels, position.userScrollDirection);

    if (direction == ScrollDirection.forward) {
      _animationController.reverse();
    } else if (direction == ScrollDirection.reverse && offset > _scrollThreshold) {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 5 + MediaQuery.sizeOf(context).height * 0.1,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SlideTransition(position: _animation, child: AppBackButton(onTap: () => Navigator.pop(context))),
      ),
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
      onTap: () => context.openBottomSheet(_TimePicker(onDateTimeChanged: onDateTimeChanged)),
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

class _TimePicker extends StatelessWidget {
  const _TimePicker({required this.onDateTimeChanged});

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

class _CountOfSeats extends StatelessWidget {
  const _CountOfSeats();

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 12),
        Text('Количество мест', style: texts.body.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(width: 12),
        const Expanded(
          child: AppTextField(
            maxLines: 1,
            textAlign: TextAlign.center,
            hintText: '10',
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

class _Options extends StatefulWidget {
  const _Options({required super.key, required this.controller, required this.onAdd, required this.onDelete});

  final TextEditingController controller;
  final VoidCallback onAdd;
  final VoidCallback onDelete;

  @override
  State<_Options> createState() => _OptionsState();
}

class _OptionsState extends State<_Options> {
  bool _isShowAddButton = false;
  bool _isSave = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_textControllerListener);
  }

  void _textControllerListener() {
    if (_isShowAddButton) return;
    if (widget.controller.text.isNotEmpty && widget.controller.text.length > 5) {
      setState(() => _isShowAddButton = true);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_textControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;

    if (_isSave) {
      return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Align(alignment: Alignment.centerRight, child: Icon(Icons.delete, color: colors.inverse)),
          ),
        ),
        onDismissed: (_) => widget.onDelete(),
        child: AppTextField(readOnly: true, controller: widget.controller),
      );
    }

    return Row(
      children: [
        Expanded(child: AppTextField(maxLines: 1, controller: widget.controller)),
        if (_isShowAddButton) ...[
          const SizedBox(width: 8),
          _AddOptionButton(
            onTap: () {
              widget.onAdd();
              setState(() => _isSave = true);
            },
          ),
        ],
      ],
    );
  }
}

class _AddOptionButton extends StatelessWidget {
  const _AddOptionButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: 36,
        child: DecoratedBox(
          decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
          child: Icon(Icons.add, color: colors.inverse),
        ),
      ),
    );
  }
}

class _Spot extends StatelessWidget {
  const _Spot({required this.onSelect, this.isSelect = false});

  final VoidCallback onSelect;
  final bool isSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    final texts = context.themes.main.texts;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: '',
          errorWidget:
              (_, __, ___) => Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(color: colors.secondary, shape: BoxShape.circle),
              ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Surf x Post', style: texts.bodySmall.copyWith(fontWeight: FontWeight.w600, height: 1.3)),
              const SizedBox(height: 4),
              Text('Краснодар, Мира 366', style: texts.bodySmall),
            ],
          ),
        ),
        _SelectSpotButton(onTap: onSelect, isSelect: isSelect),
      ],
    );
  }
}

class _SelectSpotButton extends StatelessWidget {
  const _SelectSpotButton({required this.onTap, required this.isSelect});

  final VoidCallback onTap;
  final bool isSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;

    return GestureDetector(
      onTap: onTap,
      child:
          isSelect
              ? SizedBox.square(
                dimension: 36,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
                  child: Icon(Icons.check_outlined, color: colors.inverse, size: 18),
                ),
              )
              : SizedBox.square(
                dimension: 36,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                  ),
                ),
              ),
    );
  }
}
