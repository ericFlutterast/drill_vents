import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.onTapUpOutside,
    this.hintText,
    this.hintStyle,
    this.decoration,
    this.border,
    this.contentPadding,
    this.controller,
  });

  final String? hintText;
  final TextStyle? hintStyle;
  final InputDecoration? decoration;
  final InputBorder? border;
  final EdgeInsets? contentPadding;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function(PointerDownEvent)? onTapOutside;
  final Function(String, Map<String, dynamic>)? onAppPrivateCommand;
  final Function(PointerUpEvent)? onTapUpOutside;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: context.themes.main.colors.accent,
      onChanged: onChanged,
      onTap: onTap,
      onTapOutside: onTapOutside,
      onEditingComplete: onEditingComplete,
      onAppPrivateCommand: onAppPrivateCommand,
      onSubmitted: onSubmitted,
      onTapUpOutside: onTapUpOutside,

      decoration:
          decoration ??
          InputDecoration(
            hintText: hintText,
            hintStyle: hintStyle ?? context.themes.main.texts.body.copyWith(color: context.themes.main.colors.greyDark),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border:
                border ??
                const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  borderSide: BorderSide.none,
                ),
            contentPadding: contentPadding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
          ),
    );
  }
}
