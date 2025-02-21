import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, this.onTap, this.title, this.backgroundColor, this.titleStyle});

  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final VoidCallback? onTap;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      child: Ink(
        decoration: BoxDecoration(
          color:
              backgroundColor ??
              (onTap == null ? context.themes.main.colors.greyDark : context.themes.main.colors.accent),
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text(
              title ?? '',
              style:
                  titleStyle ?? context.themes.main.texts.body.copyWith(color: context.themes.main.colors.background),
            ),
          ),
        ),
      ),
    );
  }
}
