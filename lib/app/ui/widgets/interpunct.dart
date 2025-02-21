import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

///Circular point before some word or row
class Interpunct extends StatelessWidget {
  const Interpunct({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 5,
      child: DecoratedBox(
        decoration: BoxDecoration(color: context.themes.main.colors.secondary, shape: BoxShape.circle),
      ),
    );
  }
}
