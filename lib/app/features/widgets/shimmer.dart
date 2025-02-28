import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/widgets.dart';

class Shimmer extends StatelessWidget {
  const Shimmer({super.key, this.height, this.width, this.borderRadius = 6});

  final double? height;
  final double? width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.themes.main.colors.background,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: SizedBox(height: height ?? double.infinity, width: width ?? double.infinity),
    );
  }
}
