import 'package:drill_events/app/blocs/auth.dart';
import 'package:drill_events/app/blocs/profile_bloc.dart';
import 'package:drill_events/app/features/widgets/app_text_field.dart';
import 'package:drill_events/app/generated/assets.gen.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//TODO: Сделать валидацию
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
  late final _mailController = TextEditingController();
  late final _phoneController = TextEditingController();
  late final _telegramController = TextEditingController();
  late final _whatsAppController = TextEditingController();
  late final _vkController = TextEditingController();

  late final _phoneFocusNode = FocusNode();
  late final _whatsappFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthBloc>().state.value;
    _nameController.text = user.info.name ?? '';
    _mailController.text = user.email;
    _phoneController.text = user.info.phone ?? '';
    _telegramController.text = user.info.telegram ?? '';
    _whatsAppController.text = user.info.whatsapp ?? '';
    _vkController.text = user.info.vk ?? '';

    _phoneFocusNode.addListener(() {
      if (!_phoneFocusNode.hasFocus) {
        context.read<ProfileBloc>().add(UpdateProfileInfoEvent(phone: _phoneController.text));
      }
    });
    _whatsappFocusNode.addListener(() {
      if (!_whatsappFocusNode.hasFocus) {
        context.read<ProfileBloc>().add(UpdateProfileInfoEvent(whatsapp: _whatsAppController.text));
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mailController.dispose();
    _phoneController.dispose();
    _telegramController.dispose();
    _whatsAppController.dispose();
    _vkController.dispose();
    _phoneFocusNode.dispose();
    _whatsappFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;

    return SingleChildScrollView(
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
            onEditingComplete: () {
              context.read<ProfileBloc>().add(UpdateProfileInfoEvent(name: _nameController.text));
            },
          ),
          const SizedBox(height: 8),
          AppTextField(
            controller: _mailController,
            hintText: 'Эл. почта',
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
            onEditingComplete: () {
              context.read<ProfileBloc>().add(UpdateProfileInfoEvent(email: _mailController.text));
            },
          ),
          const SizedBox(height: 8),
          AppTextField(
            focusNode: _phoneFocusNode,
            controller: _phoneController,
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
            onEditingComplete: () {
              context.read<ProfileBloc>().add(UpdateProfileInfoEvent(telegram: _telegramController.text));
            },
          ),
          const SizedBox(height: 8),
          AppTextField(
            focusNode: _whatsappFocusNode,
            controller: _whatsAppController,
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
            onEditingComplete: () {
              context.read<ProfileBloc>().add(UpdateProfileInfoEvent(vk: _vkController.text));
            },
          ),
        ],
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
