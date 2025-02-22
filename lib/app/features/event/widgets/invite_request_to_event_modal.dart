import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/blocs/sign_up_to_event/bloc.dart';
import 'package:drill_events/app/blocs/sign_up_to_event/events.dart';
import 'package:drill_events/app/features/event/widgets/event_description_tile.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/app_text_field.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/di/dependencies_scope.dart';
import 'package:drill_events/common/shared_preferences/shared_preferences_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class JoinEventModal extends StatefulWidget {
  const JoinEventModal({super.key, required this.conditionsForParticipation});

  final Iterable<String> conditionsForParticipation;

  static Widget bloc(BuildContext context, {required Iterable<String> conditionsForParticipation}) {
    return BlocProvider(
      create: (_) => DependenciesScope.of(context).dependencies.signUpToEventBloc,
      child: JoinEventModal(conditionsForParticipation: conditionsForParticipation),
    );
  }

  @override
  State<JoinEventModal> createState() => _InviteRequestToEventModalState();
}

class _InviteRequestToEventModalState extends State<JoinEventModal> {
  late final _emailFormControl = FormControl<String>(validators: [Validators.email], value: '');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //TODO: Эта штука должна быть в блоке
    final email = DependenciesScope.of(context).dependencies.sharedPreferences.getString(SharedPrefKeys.email);
    _emailFormControl.value = email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 700),
        child: BlocBuilder<SignUpToEventBloc, CommonBlocState>(
          builder: (context, state) {
            if (state.isPending) {
              return const _CreateSignUp();
            }

            if (state.isDone) {
              return const _SignUpDone.success();
            }

            if (state.isError) {
              return const _SignUpDone.error();
            }

            return Column(
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
                    return AppButton(
                      title: 'Отправить заявку',
                      onTap:
                          isValid
                              ? () => context.read<SignUpToEventBloc>().add(SignUpEvent(email: form.value ?? ''))
                              : null,
                    );
                  },
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SignUpDone extends StatelessWidget {
  const _SignUpDone.success()
    : _icon = Icons.check_outlined,
      _title = 'Вы записаны!',
      _message = 'Ваша заявка отправлена\nна рассмотрение',
      _buttonTitle = 'Отлично!',
      _isSuccess = true;

  const _SignUpDone.error()
    : _icon = Icons.close_outlined,
      _title = 'Ошибка!',
      _message = 'Не удалось записаться на мероприятие, попробуйте позже',
      _buttonTitle = 'Блин...',
      _isSuccess = false;

  final IconData _icon;
  final String _title, _message, _buttonTitle;
  final bool _isSuccess;

  @override
  Widget build(BuildContext context) {
    final iconColor = _isSuccess ? context.themes.main.colors.success600 : context.themes.main.colors.error600;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
              child: Icon(_icon, color: context.themes.main.colors.inverse),
            ),
          ),
          const SizedBox(height: 12),
          Text(_title, style: context.themes.main.texts.h3),
          const SizedBox(height: 5),
          Text(_message, textAlign: TextAlign.center, style: context.themes.main.texts.body),
          const SizedBox(height: 36),
          AppButton(onTap: () => Navigator.pop(context), title: _buttonTitle),
        ],
      ),
    );
  }
}

class _CreateSignUp extends StatelessWidget {
  const _CreateSignUp();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(color: context.themes.main.colors.warning600, shape: BoxShape.circle),
                child: Icon(Icons.access_time_rounded, color: context.themes.main.colors.inverse),
              ),
            ),
            const SizedBox(height: 12),
            Text('Записываемся...', style: context.themes.main.texts.h3),
          ],
        ),
      ),
    );
  }
}
