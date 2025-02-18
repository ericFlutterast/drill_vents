import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyles = context.themes.main.texts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Anatoly', style: textStyles.h3),
        const SizedBox(height: 5),
        Text('anatoly_washer@gmail.com', style: textStyles.bodySmall),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/telegram.svg'),
            const SizedBox(width: 8),
            Text('t.me/@vladimirshmondenko', style: textStyles.bodySmall),
          ],
        ),
      ],
    );
  }
}
