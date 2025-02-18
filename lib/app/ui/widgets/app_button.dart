import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, this.onTap, this.title});

  final VoidCallback? onTap;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      child: Ink(
        decoration: BoxDecoration(
          color: onTap == null ? context.themes.main.colors.greyDark : context.themes.main.colors.accent,
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.5),
          child: Center(
            child: Text(
              title ?? '',
              style: context.themes.main.texts.body.copyWith(color: context.themes.main.colors.background),
            ),
          ),
        ),
      ),
    );
  }
}
