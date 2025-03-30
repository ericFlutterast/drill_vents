import 'package:drill_events/app/blocs/auth.dart';
import 'package:drill_events/app/features/widgets/app_back_button.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/app_notification.dart';
import 'package:drill_events/app/features/widgets/app_text_field.dart';
import 'package:drill_events/app/features/widgets/notification_manager.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final FocusNode _mailFocus = FocusNode();
  late final FocusNode _passwordFocus = FocusNode();

  late final _authFormGroup = FormGroup({
    'email': FormControl<String>(value: 'test11@mail.com', validators: [Validators.email, Validators.required]),
    'password': FormControl<String>(value: '123456789', validators: [Validators.minLength(8), Validators.required]),
  });

  @override
  void dispose() {
    _mailFocus.dispose();
    _passwordFocus.dispose();
    _authFormGroup.dispose();
    super.dispose();
  }

  void _blocListener(BuildContext context, AuthState state) {
    if (state.isDone && state.hasValue) {
      Navigator.pushReplacementNamed(context, Routes.profile);
    }

    if (state.hasError) {
      NotificationManager.of(context).showNotification(
        notification: AppNotification(status: NotificationStatus.error, message: state.errorMessage.toString()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    final texts = context.themes.main.texts;

    return Scaffold(
      backgroundColor: colors.inverse,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: _blocListener,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
                  const Padding(padding: EdgeInsets.only(left: 20), child: AppBackButton()),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Drill Vents', style: texts.h1),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: AppTextField(
                      onEditingComplete: () => _mailFocus.nextFocus(),
                      focusNode: _mailFocus,
                      useReactiveForm: true,
                      formControl: _authFormGroup.controls['email'] as FormControl,
                      maxLines: 1,
                      hintText: 'mail@domain.com',
                      keyboardType: TextInputType.emailAddress,
                      focusBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colors.primary, width: 1.5),
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: AppTextField(
                      focusNode: _passwordFocus,
                      useReactiveForm: true,
                      formControl: _authFormGroup.controls['password'] as FormControl,
                      maxLines: 1,
                      hintText: '********',
                      obscureText: true,
                      focusBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colors.primary, width: 1.5),
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 46),
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state.isPending) {
                          return const AppButton.loading(title: 'Войти');
                        }

                        return ReactiveFormBuilder(
                          form: () => _authFormGroup,
                          builder: (context, formGroup, child) {
                            return AppButton.primary(title: 'Войти', onTap: () => _createSession(formGroup));
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.13),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _createSession(FormGroup formGroup) {
    formGroup.value;
    if (formGroup.valid) {
      if (formGroup.value case <String, Object?>{'email': final String email, 'password': final String password}) {
        context.read<AuthBloc>().add(CreateSessionEvent(email: email, password: password));
      }
    }
  }
}
