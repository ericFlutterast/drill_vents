import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Shimmer extends StatelessWidget {
  const Shimmer({super.key, this.height, this.width, this.borderRadius = 6});

  final double? height;
  final double? width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    return DecoratedBox(
          decoration: BoxDecoration(
            color: context.themes.main.colors.background,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: SizedBox(height: height ?? double.infinity, width: width ?? double.infinity),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: const Duration(milliseconds: 900),
          delay: const Duration(milliseconds: 300),
          color: colors.inverse,
        );
  }
}
