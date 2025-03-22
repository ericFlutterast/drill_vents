import 'package:drill_events/app/features/event/evetn_user/widgets/event_description_tile.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/app_text_field.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PromptEmailPassword extends StatefulWidget {
  const PromptEmailPassword({super.key, required this.conditionsForParticipation});

  final Iterable<String> conditionsForParticipation;

  @override
  State<PromptEmailPassword> createState() => _InviteRequestToEventModalState();
}

class _InviteRequestToEventModalState extends State<PromptEmailPassword> {
  bool _showPasswordField = false;
  String _title = 'Условия';

  late final _emailControl = FormControl<String>(validators: [Validators.email], value: '');
  late final _passwordControl = FormControl<String>(
    validators: [Validators.required, Validators.minLength(8)],
    value: '',
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          EventDescriptionTile(
            title: _title,
            subtitle: _showPasswordField ? 'Придумайте пароль и может быть мы вас пропустим' : null,
            titleStyle: context.themes.main.texts.h3,
            descriptionRows:
                _showPasswordField
                    ? ['Минимальная длина члена 88см', 'Включите слово “ponos” в пароль', 'Любое название трека NF']
                    : widget.conditionsForParticipation,
          ),
          const SizedBox(height: 36),
          if (_showPasswordField) ...[
            AppTextField(
              key: UniqueKey(),
              maxLines: 1,
              useReactiveForm: true,
              obscureText: true,
              hintText: 'Password',
              formControl: _passwordControl,
            ),
            const SizedBox(height: 12),
          ] else ...[
            AppTextField(
              key: UniqueKey(),
              useReactiveForm: true,
              maxLines: 1,
              hintText: 'Email',
              formControl: _emailControl,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 36),
          ],

          ReactiveValueListenableBuilder(
            formControl: _showPasswordField ? _passwordControl : _emailControl,
            builder: (context, form, _) {
              final isValid = form.valid && form.value != null && form.value!.isNotEmpty;

              if (_showPasswordField) {
                return AppButton.primary(
                  title: 'Создать аккаунт и записаться',
                  onTap:
                      isValid
                          ? () => Navigator.pop<List<String>>(context, [
                            _emailControl.value ?? (throw 'Никогда не null'),
                            _passwordControl.value ?? (throw 'Никогда не null'),
                          ])
                          : null,
                );
              }

              return AppButton.primary(
                title: 'Записаться',
                onTap:
                    isValid
                        ? () {
                          setState(() {
                            _showPasswordField = true;
                            _title = 'Остался последний шаг ';
                          });
                        }
                        : null,
              );
            },
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
        ],
      ),
    );
  }
}
