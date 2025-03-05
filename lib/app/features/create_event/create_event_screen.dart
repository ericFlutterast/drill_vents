import 'package:drill_events/app/blocs/create_new_event.dart';
import 'package:drill_events/app/features/create_event/new_event_validators.dart';
import 'package:drill_events/app/features/create_event/widgets/date_time_picker.dart';
import 'package:drill_events/app/features/create_event/widgets/options_tile.dart';
import 'package:drill_events/app/features/create_event/widgets/spots_tile.dart';
import 'package:drill_events/app/features/event/widgets/participation_notification.dart';
import 'package:drill_events/app/features/widgets/app_back_button.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/app_text_field.dart';
import 'package:drill_events/app/features/widgets/notification_manager.dart';
import 'package:drill_events/app/features/widgets/validation_builder.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen._({super.key});

  static Widget bloc(BuildContext context, {Key? key}) {
    return BlocProvider<CreateNewEventBloc>(
      create: (context) => context.dependencies.createNewEventBloc,
      child: CreateEventScreen._(key: key),
    );
  }

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  late final _scrollController = ScrollController();

  EventValidation eventValidation = EventValidation({
    'dateTime': DateTimeValidator(),
    'title': TitleValidator(),
    'description': DescriptionValidator(),
    'capacity': CapacityValidator(),
    'spotId': SpotIdValidator(),
  });

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _createEvent() {
    if (eventValidation.isValidate) {
      if (eventValidation.validators case <String, Validator>{
        'title': final title,
        'description': final description,
        'dateTime': final DateTimeValidator dateTime,
        'capacity': final capacity,
        'spotId': final spotId,
      }) {
        context.read<CreateNewEventBloc>().add(
          CreateNewEvent(
            title: title.value,
            capacity: capacity.value,
            description: description.value,
            endTime: dateTime.value?.endTime,
            startTime: dateTime.value?.startTime ?? DateTime.now(),
            startDate: dateTime.value?.endTime ?? DateTime.now(),
            spotId: spotId.value,
          ),
        );
      }
    } else {
      _scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.linear);
    }
  }

  void _createEventBlocListener(BuildContext _, CreateNewEventState state) {
    if (state.isDone) {
      NotificationManager.of(context).showNotification(
        notification: const ParticipationNotification(
          title: 'Событие успешно создано',
          status: ParticipationNotificationStatus.success,
        ),
      );
    }

    if (state.isError) {
      NotificationManager.of(context).showNotification(
        notification: const ParticipationNotification(message: 'Ошибка', status: ParticipationNotificationStatus.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;

    return Scaffold(
      backgroundColor: colors.inverse,
      body: BlocListener<CreateNewEventBloc, CreateNewEventState>(
        listener: _createEventBlocListener,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 180, 20, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Heading(),
                    const SizedBox(height: 28),
                    DateTimePicker(validator: eventValidation.validators['dateTime'] as DateTimeValidator),
                    const SizedBox(height: 32),
                    _MainInformation(
                      titleValidator: eventValidation.validators['title']!,
                      descriptionValidator: eventValidation.validators['description']!,
                    ),
                    const SizedBox(height: 24),
                    _Capacity(validator: eventValidation.validators['capacity']!),
                    const SizedBox(height: 24),
                    OptionsTile(title: 'Ожидания от участников', onEditingComplete: (value) {}),
                    const SizedBox(height: 24),
                    OptionsTile(title: 'Мы обеспечим', onEditingComplete: (value) {}),
                    const SizedBox(height: 32),
                    SpotsTile.bloc(context, validator: eventValidation.validators['spotId']!),
                    const SizedBox(height: 24),
                    BlocBuilder<CreateNewEventBloc, CreateNewEventState>(
                      builder: (context, state) {
                        if (state.isPending) {
                          return const AppButton.loading(title: 'Опубликовать');
                        }

                        return AppButton.primary(title: 'Опубликовать', onTap: _createEvent);
                      },
                    ),
                  ],
                ),
              ),
              _PositionedBackButton(scrollController: _scrollController),
            ],
          ),
        ),
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

class _MainInformation extends StatefulWidget {
  const _MainInformation({required this.titleValidator, required this.descriptionValidator});

  final Validator titleValidator;
  final Validator descriptionValidator;

  @override
  State<_MainInformation> createState() => _MainInformationState();
}

class _MainInformationState extends State<_MainInformation> {
  late final FocusNode _nameFocus;
  late final FocusNode _descriptionFocus;
  late final TextEditingController _nameTextController;
  late final TextEditingController _descriptionTextController;

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController();
    _descriptionTextController = TextEditingController();
    _nameFocus = FocusNode();
    _descriptionFocus = FocusNode();

    _nameTextController.addListener(_nameTextControllerListener);
    _descriptionFocus.addListener(_descriptionFocusListener);
  }

  void _nameTextControllerListener() {
    if (!_nameFocus.hasFocus) {
      widget.titleValidator.value = _nameTextController.text;
    }
  }

  void _descriptionFocusListener() {
    if (!_descriptionFocus.hasFocus) {
      widget.descriptionValidator.value = _descriptionTextController.text;
    }
  }

  @override
  void dispose() {
    _nameTextController.removeListener(_nameTextControllerListener);
    _descriptionFocus.removeListener(_descriptionFocusListener);
    _nameTextController.dispose();
    _descriptionTextController.dispose();
    _descriptionFocus.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValidationBuilder(
          validator: widget.titleValidator,
          builder: (context, value, child) {
            return AppTextField(
              focusNode: _nameFocus,
              controller: _nameTextController,
              hintText: 'Имя',
              maxLines: 1,
              onEditingComplete: () => _nameFocus.nextFocus(),
              onTapUpOutside: (_) => widget.titleValidator.value = _nameTextController.text,
            );
          },
        ),
        const SizedBox(height: 12),
        ValidationBuilder(
          validator: widget.descriptionValidator,
          builder: (context, value, child) {
            return AppTextField(
              focusNode: _descriptionFocus,
              controller: _descriptionTextController,
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
            );
          },
        ),
      ],
    );
  }
}

class _Capacity extends StatefulWidget {
  const _Capacity({required this.validator});

  final Validator validator;

  @override
  State<_Capacity> createState() => _CapacityState();
}

class _CapacityState extends State<_Capacity> {
  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;

    return ValidationBuilder(
      validator: widget.validator,
      builder: (_, __, widget) => widget!,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 12),
          Text('Количество мест', style: texts.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          Expanded(
            child: AppTextField(
              onChanged: (count) => widget.validator.value = int.parse(count),
              maxLines: 1,
              textAlign: TextAlign.center,
              hintText: '10',
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
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
