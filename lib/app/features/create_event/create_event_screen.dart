import 'package:drill_events/app/features/create_event/widgets/date_time_picker.dart';
import 'package:drill_events/app/features/create_event/widgets/options_tile.dart';
import 'package:drill_events/app/features/create_event/widgets/spots_tile.dart';
import 'package:drill_events/app/features/widgets/app_back_button.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/app_text_field.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  late final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;

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
                    const _Heading(),
                    const SizedBox(height: 28),
                    const DateTimePicker(),
                    const SizedBox(height: 32),
                    const _MainInformation(),
                    const SizedBox(height: 24),
                    const _CountOfSeats(),
                    const SizedBox(height: 24),
                    const OptionsTile(title: 'Ожидания от участников'),
                    const SizedBox(height: 24),
                    const OptionsTile(title: 'Мы обеспечим'),
                    const SizedBox(height: 32),
                    const SpotsTile(),
                    const SizedBox(height: 24),
                    AppButton.primary(
                      title: 'Опубликовать',
                      onTap: () {
                        //TODO: create event
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          _PositionedBackButton(scrollController: _scrollController),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading();

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;

    return Padding(padding: const EdgeInsets.symmetric(horizontal: 9), child: Text('Новое событие', style: texts.h1));
  }
}

class _MainInformation extends StatelessWidget {
  const _MainInformation();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      ],
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

class _PositionedBackButton extends StatefulWidget {
  const _PositionedBackButton({required this.scrollController});

  final ScrollController scrollController;

  @override
  State<_PositionedBackButton> createState() => _CreateEventHeaderState();
}

class _CreateEventHeaderState extends State<_PositionedBackButton> with SingleTickerProviderStateMixin {
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
