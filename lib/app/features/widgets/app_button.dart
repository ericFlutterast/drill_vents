import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, this.onTap, this.title, this.backgroundColor, this.titleStyle, this.isLoading = false});

  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final VoidCallback? onTap;
  final String? title;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      child: Ink(
        decoration: BoxDecoration(
          color:
              backgroundColor ??
              (onTap == null || isLoading ? context.themes.main.colors.background : context.themes.main.colors.primary),
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  SizedBox.square(
                    dimension: 17,
                    child: CircularProgressIndicator(color: context.themes.main.colors.warning600, strokeWidth: 2),
                  ),
                  const SizedBox(width: 10),
                ],
                Text(
                  title ?? '',
                  style:
                      titleStyle ??
                      context.themes.main.texts.body.copyWith(
                        color:
                            onTap == null || isLoading
                                ? context.themes.main.colors.secondary
                                : context.themes.main.colors.inverse,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
