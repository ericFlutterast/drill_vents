import 'package:drill_events/app/blocs/auth.dart';
import 'package:drill_events/app/blocs/profile_bloc.dart';
import 'package:drill_events/app/features/widgets/app_text_field.dart';
import 'package:drill_events/app/generated/assets.gen.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EditingProfileModal extends StatefulWidget {
  const EditingProfileModal._({super.key});

  static Widget blocValue(
    BuildContext context, {
    Key? key,
    required AuthBloc authBloc,
    required ProfileBloc profileBloc,
  }) {
    return MultiBlocProvider(
      providers: [BlocProvider<AuthBloc>.value(value: authBloc), BlocProvider<ProfileBloc>.value(value: profileBloc)],
      child: EditingProfileModal._(key: key),
    );
  }

  @override
  State<EditingProfileModal> createState() => _EditingProfileModalState();
}

class _EditingProfileModalState extends State<EditingProfileModal> {
  late final _nameController = TextEditingController();
  late final _telegramController = TextEditingController();
  late final _vkController = TextEditingController();

  late final _emailControl = FormControl<String>(validators: [Validators.email]);
  late final _phoneControl = FormControl<String>(validators: [_PhoneNumberValidator()]);
  late final _whatsappControl = FormControl<String>(validators: [_PhoneNumberValidator()]);

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthBloc>().state.value;
    _nameController.text = user.info.name ?? '';
    _emailControl.value = user.email;
    _phoneControl.value = user.info.phone ?? '';
    _telegramController.text = user.info.telegram ?? '';
    _whatsappControl.value = user.info.whatsapp ?? '';
    _vkController.text = user.info.vk ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailControl.dispose();
    _phoneControl.dispose();
    _telegramController.dispose();
    _whatsappControl.dispose();
    _vkController.dispose();
    super.dispose();
  }

  void _onEditingComplete([VoidCallback? cb]) {
    cb?.call();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;

    return PopScope(
      onPopInvokedWithResult: (invoke, result) {
        context.read<ProfileBloc>().add(
          UpdateProfileInfoEvent(
            name: _nameController.text,
            whatsapp: _whatsappControl.value,
            telegram: _telegramController.text,
            phone: _phoneControl.value,
            vk: _vkController.text,
            email: _emailControl.value,
          ),
        );
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: const EdgeInsets.only(left: 8), child: Text('Контактные данные', style: texts.h3)),
            const SizedBox(height: 32),
            AppTextField(
              controller: _nameController,
              hintText: 'Имя',
              keyboardType: TextInputType.name,
              maxLines: 1,
              onEditingComplete: () => _onEditingComplete(),
            ),
            const SizedBox(height: 8),
            AppTextField(
              useReactiveForm: true,
              formControl: _emailControl,
              hintText: 'Эл. почта',
              keyboardType: TextInputType.emailAddress,
              maxLines: 1,
              onEditingComplete:
                  () => _onEditingComplete(() {
                    if (!_emailControl.valid) {
                      _emailControl.markAsDirty();
                      _emailControl.markAsTouched();
                    }
                  }),
            ),
            const SizedBox(height: 8),
            AppTextField(
              useReactiveForm: true,
              formControl: _phoneControl,
              hintText: '+7777777777 (номер)',
              keyboardType: TextInputType.phone,
              maxLines: 1,
              inputFormatters: [_PhoneNumberFormatter()],
            ),
            const SizedBox(height: 8),
            AppTextField(
              controller: _telegramController,
              hintText: '@telegram',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SizedBox.square(dimension: 25, child: Assets.icons.telegram.svg()),
              ),
              prefixIconConstraints: const BoxConstraints(maxWidth: 40, maxHeight: 25),
              maxLines: 1,
              onTapOutside: (_) => _onEditingComplete(),
              onEditingComplete: () => _onEditingComplete(),
            ),
            const SizedBox(height: 8),
            AppTextField(
              useReactiveForm: true,
              formControl: _whatsappControl,
              hintText: '+7777777777 (WhatsApp)',
              keyboardType: TextInputType.phone,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SizedBox.square(dimension: 25, child: Assets.icons.telegram.svg()),
              ),
              prefixIconConstraints: const BoxConstraints(maxWidth: 40, maxHeight: 25),
              maxLines: 1,
              inputFormatters: [_PhoneNumberFormatter()],
            ),
            const SizedBox(height: 8),
            AppTextField(
              controller: _vkController,
              hintText: 'link (vk)',
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SizedBox.square(dimension: 25, child: Assets.icons.telegram.svg()),
              ),
              prefixIconConstraints: const BoxConstraints(maxWidth: 40, maxHeight: 25),
              maxLines: 1,
              onEditingComplete: () => _onEditingComplete(),
            ),
          ],
        ),
      ),
    );
  }
}

final class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 12) return oldValue;
    if (oldValue.text.isEmpty) return TextEditingValue(text: '+7${newValue.text}');
    return newValue;
  }
}

final class _PhoneNumberValidator extends Validator<String> {
  @override
  Map<String, dynamic>? validate(AbstractControl<String> control) {
    if (control.value != null) {
      if (control.value!.contains(RegExp(r'^\+[0-9]+$')) && control.value!.length == 12) {
        return null;
      }
    }

    return {'Неверный формат': true};
  }
}
