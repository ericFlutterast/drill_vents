import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

class CreatingEntryForEventModal extends StatelessWidget {
  const CreatingEntryForEventModal({super.key});

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
