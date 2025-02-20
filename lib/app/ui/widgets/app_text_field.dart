import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

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
    this.formControl,
    this.keyboardType,
    this.useReactiveForm = false,
  });

  final String? hintText;
  final TextStyle? hintStyle;
  final InputDecoration? decoration;
  final InputBorder? border;
  final EdgeInsets? contentPadding;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final FormControl? formControl;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function(PointerDownEvent)? onTapOutside;
  final Function(String, Map<String, dynamic>)? onAppPrivateCommand;
  final Function(PointerUpEvent)? onTapUpOutside;
  final bool useReactiveForm;

  @override
  Widget build(BuildContext context) {
    if (useReactiveForm) {
      return ReactiveTextField(
        controller: controller,
        formControl: formControl,
        cursorColor: context.themes.main.colors.accent,
        onTapOutside: onTapOutside,
        onAppPrivateCommand: onAppPrivateCommand,
        keyboardType: keyboardType,

        decoration:
            decoration ??
            InputDecoration(
              hintText: hintText,
              hintStyle:
                  hintStyle ?? context.themes.main.texts.body.copyWith(color: context.themes.main.colors.greyDark),
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
      keyboardType: keyboardType,

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
