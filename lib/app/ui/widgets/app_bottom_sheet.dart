import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({super.key, this.child, this.height, this.borderRadius});

  final Widget? child;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? MediaQuery.sizeOf(context).height * 0.4,
      width: double.infinity,
      child: Material(
        color: context.themes.main.colors.background,
        borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(32)),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const SizedBox(
              height: 4,
              width: 42,
              child: DecoratedBox(
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)), color: Color(0xFFEDEDED)),
              ),
            ),
            const SizedBox(height: 10),
            if (child != null) Expanded(child: child!),
          ],
        ),
      ),
    );
  }
}
