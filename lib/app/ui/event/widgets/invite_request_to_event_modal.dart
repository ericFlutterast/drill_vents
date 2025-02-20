import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/app/ui/event/widgets/event_description_tile.dart';
import 'package:drill_events/app/ui/widgets/app_button.dart';
import 'package:drill_events/app/ui/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class InviteRequestToEventModal extends StatefulWidget {
  const InviteRequestToEventModal({super.key, required this.conditionsForParticipation});

  final Iterable<String> conditionsForParticipation;

  @override
  State<InviteRequestToEventModal> createState() => _InviteRequestToEventModalState();
}

class _InviteRequestToEventModalState extends State<InviteRequestToEventModal> {
  late final _emailFormControl = FormControl<String>(validators: [Validators.email], value: '');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          EventDescriptionTile(
            title: 'Условия',
            titleStyle: context.themes.main.texts.h3,
            descriptionRows: widget.conditionsForParticipation,
          ),
          const SizedBox(height: 36),
          AppTextField(
            useReactiveForm: true,
            hintText: 'Email',
            formControl: _emailFormControl,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 36),
          ReactiveValueListenableBuilder(
            formControl: _emailFormControl,
            builder: (context, form, _) {
              final isValid = form.valid && form.value != null && form.value!.isNotEmpty;
              return AppButton(title: 'Отправить заявку', onTap: isValid ? () {} : null);
            },
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
        ],
      ),
    );
  }
}
