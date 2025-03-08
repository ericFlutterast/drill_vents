import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(100)),
      onTap: onTap,
      child: SizedBox.square(
        dimension: 42,
        child: Ink(
          decoration: BoxDecoration(color: context.themes.main.colors.background, shape: BoxShape.circle),
          child: const Icon(Icons.arrow_back, size: 24),
        ),
      ),
    );
  }
}
