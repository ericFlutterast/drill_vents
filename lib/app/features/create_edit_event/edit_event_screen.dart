import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/blocs/edit_event.dart';
import 'package:drill_events/app/features/create_edit_event/validators/event_validators.dart';
import 'package:drill_events/app/features/create_edit_event/widgets/date_time_picker.dart';
import 'package:drill_events/app/features/create_edit_event/widgets/options_tile.dart';
import 'package:drill_events/app/features/create_edit_event/widgets/spots_tile.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/app_notification.dart';
import 'package:drill_events/app/features/widgets/app_text_field.dart';
import 'package:drill_events/app/features/widgets/notification_manager.dart';
import 'package:drill_events/app/features/widgets/screen_header.dart';
import 'package:drill_events/app/features/widgets/validation_builder.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class EditEventsArgs {
  const EditEventsArgs(this.event);

  final DetailEventModel event;
}

class EditEventScreen extends StatefulWidget {
  const EditEventScreen({super.key});

  static Widget bloc(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return EditEventBloc(logger: context.dependencies.logger, api: context.dependencies.backendApi);
      },
      child: const EditEventScreen(),
    );
  }

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late final _scrollController = ScrollController();

  late EventValidation eventValidation;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final event = context.getArgs<EditEventsArgs>().event;
    final startDate = DateTime.parse(event.startDate);
    final startTime = DateTime.parse(event.startTime);
    DateTime? endTime;
    if (event.endTime case String endTimeAsString) {
      endTime = DateTime.parse(endTimeAsString);
    }

    eventValidation = EventValidation({
      'dateTime': DateTimeValidator(DateTimeModel(startTime: startTime, startDate: startDate, endTime: endTime)),
      'title': Validator<String>(event.title),
      'description': Validator<String>(event.description),
      'capacity': Validator<int>(event.capacity),
      'spotId': Validator<String>(event.spot.id),
    });
  }

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
        final eventId = context.getArgs<EditEventsArgs>().event.id;
        context.read<EditEventBloc>().add(
          EditEvent(
            eventId: eventId,
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

  void _createEventBlocListener(BuildContext _, CommonBlocState state) {
    if (state.isDone) {
      NotificationManager.of(context).showNotification(
        notification: const AppNotification(title: 'Событие успешно обновлено', status: NotificationStatus.success),
      );
    }

    if (state.isError) {
      NotificationManager.of(
        context,
      ).showNotification(notification: const AppNotification(message: 'Ошибка', status: NotificationStatus.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;

    return Scaffold(
      backgroundColor: colors.inverse,
      body: BlocListener<EditEventBloc, CommonBlocState>(
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
                    _Capacity(validator: eventValidation.validators['capacity']! as Validator<int>),
                    const SizedBox(height: 24),
                    OptionsTile(title: 'Ожидания от участников', onEditingComplete: (value) {}),
                    const SizedBox(height: 24),
                    OptionsTile(title: 'Мы обеспечим', onEditingComplete: (value) {}),
                    const SizedBox(height: 32),
                    SpotsTile.bloc(
                      context,
                      validator: eventValidation.validators['spotId']! as Validator<String>,
                      orgId: context.getArgs<EditEventsArgs>().event.org.id,
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<EditEventBloc, CommonBlocState>(
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
              const PositionedScreenHeader(),
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9),
      child: Text('Редактировать событие', style: texts.h1),
    );
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
    _nameTextController = TextEditingController(text: widget.titleValidator.value);
    _descriptionTextController = TextEditingController(text: widget.descriptionValidator.value);
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

  final Validator<int> validator;

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
              controller: TextEditingController(text: widget.validator.value.toString()),
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
