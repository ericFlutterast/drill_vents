import 'package:drill_events/app/features/widgets/shimmer.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/app/themes/colors_theme.dart';
import 'package:flutter/material.dart';

enum AppButtonState {
  primary,
  loading,
  secondary,
  custom,
  warning,
  error;

  bool get isLoading => this == loading;
}

class AppButton extends StatelessWidget {
  const AppButton.primary({super.key, this.onTap, this.title})
    : _state = AppButtonState.primary,
      titleStyle = null,
      loadingIconColor = null,
      splashColor = null,
      highlightColor = null,
      backgroundColor = null;

  const AppButton.secondary({super.key, this.onTap, this.title})
    : _state = AppButtonState.secondary,
      titleStyle = null,
      loadingIconColor = null,
      splashColor = null,
      highlightColor = null,
      backgroundColor = null;

  const AppButton.loading({super.key, this.title, this.loadingIconColor})
    : _state = AppButtonState.loading,
      titleStyle = null,
      onTap = null,
      splashColor = null,
      highlightColor = null,
      backgroundColor = null;

  const AppButton.custom({
    super.key,
    this.title,
    this.onTap,
    this.titleStyle,
    this.backgroundColor,
    this.loadingIconColor,
    this.splashColor,
    this.highlightColor,
  }) : _state = AppButtonState.custom;

  const AppButton.error({super.key, this.title})
    : _state = AppButtonState.error,
      onTap = null,
      titleStyle = null,
      loadingIconColor = null,
      splashColor = null,
      highlightColor = null,
      backgroundColor = null;

  const AppButton.warning({super.key, this.title, this.onTap})
    : _state = AppButtonState.warning,
      backgroundColor = null,
      loadingIconColor = null,
      splashColor = null,
      highlightColor = null,
      titleStyle = null;

  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final VoidCallback? onTap;
  final String? title;
  final Color? loadingIconColor;
  final AppButtonState _state;
  final Color? splashColor;
  final Color? highlightColor;

  Color _setBackgroundColor(AppColors colors) {
    if (onTap == null) return colors.background;

    return switch (_state) {
      AppButtonState.primary => colors.primary,
      AppButtonState.error => colors.error200,
      AppButtonState.warning => colors.warning100,
      _ => colors.background,
    };
  }

  Color _setTitleColor(AppColors colors) {
    if (onTap == null) return colors.secondary;

    return switch (_state) {
      AppButtonState.primary => colors.inverse,
      AppButtonState.secondary => colors.primary,
      AppButtonState.warning => colors.warning600,
      _ => colors.secondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    final texts = context.themes.main.texts;

    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      splashColor: splashColor,
      highlightColor: highlightColor,
      child: Ink(
        decoration: BoxDecoration(
          color: backgroundColor ?? _setBackgroundColor(colors),
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_state.isLoading) ...[
                  SizedBox.square(
                    dimension: 17,
                    child: CircularProgressIndicator(
                      color: loadingIconColor ?? context.themes.main.colors.warning600,
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Text(title ?? '', style: titleStyle ?? texts.body.copyWith(color: _setTitleColor(colors))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget shimmer() => const Shimmer(height: 50, width: double.infinity, borderRadius: 50);
}
