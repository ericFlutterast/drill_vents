import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.focusBorder,
    this.errorBorder,
    this.contentPadding,
    this.controller,
    this.formControl,
    this.keyboardType,
    this.maxLines,
    this.obscureText = false,
    this.obscuringCharacter = '*',
    this.useReactiveForm = false,
    this.isDense = false,
    this.expands = false,
    this.readOnly = false,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.inputFormatters,
  });

  final String? hintText;
  final TextStyle? hintStyle;
  final InputDecoration? decoration;
  final InputBorder? border;
  final InputBorder? focusBorder;
  final InputBorder? errorBorder;
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
  final bool obscureText;
  final bool isDense;
  final bool expands;
  final bool readOnly;
  final String obscuringCharacter;
  final int? maxLines;
  final TextAlign textAlign;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;

    if (useReactiveForm) {
      return ReactiveTextField(
        focusNode: focusNode,
        controller: controller,
        formControl: formControl,
        cursorColor: context.themes.main.colors.primary,
        onTapOutside: onTapOutside ?? (_) => FocusScope.of(context).unfocus(),
        onEditingComplete: onEditingComplete != null ? (_) => onEditingComplete?.call() : null,
        onAppPrivateCommand: onAppPrivateCommand,
        keyboardType: keyboardType,
        obscureText: obscureText,
        obscuringCharacter: obscuringCharacter,
        expands: expands,
        maxLines: maxLines,
        textAlign: textAlign,
        readOnly: readOnly,
        inputFormatters: inputFormatters,

        decoration:
            decoration ??
            InputDecoration(
              prefixIconConstraints: prefixIconConstraints,
              prefixIcon: prefixIcon,
              isDense: isDense,
              hintText: hintText,
              hintStyle:
                  hintStyle ?? context.themes.main.texts.body.copyWith(color: context.themes.main.colors.secondary),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              focusedBorder: focusBorder,
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                borderSide: BorderSide(width: 1.5, color: colors.error600),
              ),
              errorBorder:
                  errorBorder ??
                  OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(width: 1.5, color: colors.error600),
                  ),
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
      focusNode: focusNode,
      controller: controller,
      cursorColor: context.themes.main.colors.primary,
      onChanged: onChanged,
      onTap: onTap,
      onTapOutside: onTapOutside ?? (_) => FocusScope.of(context).unfocus(),
      onEditingComplete: onEditingComplete,
      onAppPrivateCommand: onAppPrivateCommand,
      onSubmitted: onSubmitted,
      onTapUpOutside: onTapUpOutside,
      keyboardType: keyboardType,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      expands: expands,
      maxLines: maxLines,
      textAlign: textAlign,
      readOnly: readOnly,
      inputFormatters: inputFormatters,

      decoration:
          decoration ??
          InputDecoration(
            prefixIcon: prefixIcon,
            prefixIconConstraints: prefixIconConstraints,
            isDense: isDense,
            hintText: hintText,
            hintStyle:
                hintStyle ?? context.themes.main.texts.body.copyWith(color: context.themes.main.colors.secondary),
            filled: true,
            fillColor: colors.background,
            errorBorder:
                errorBorder ??
                OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  borderSide: BorderSide(width: 1.5, color: colors.error600),
                ),
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
