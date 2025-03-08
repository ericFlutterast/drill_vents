import 'package:drill_events/app/features/create_event/new_event_validators.dart';
import 'package:drill_events/app/generated/assets.gen.dart';
import 'package:flutter/material.dart';

class ValidationBuilder extends StatelessWidget {
  const ValidationBuilder({super.key, required this.validator, required this.builder, this.child});

  final Validator validator;
  final ValueWidgetBuilder<bool?> builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: validator.hasError,
      builder: (_, value, __) {
        return Stack(children: [builder(context, value, child), if (value == true) Assets.icons.errorMark.svg()]);
      },
    );
  }
}
