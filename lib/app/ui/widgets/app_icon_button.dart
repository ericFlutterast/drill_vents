import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({super.key, required this.icon, this.onTap, this.dimension = 36, this.borderRadius = 8});

  final VoidCallback? onTap;
  final IconData icon;
  final double dimension;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: Ink(
          decoration: BoxDecoration(
            color: context.themes.main.colors.background,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          child: Padding(padding: const EdgeInsets.all(6), child: Icon(icon)),
        ),
      ),
    );
  }
}
