import 'package:cached_network_image/cached_network_image.dart';
import 'package:drill_events/app/features/widgets/shimmer.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.clipBehavior = Clip.hardEdge,
    this.size = 52,
    this.fit = BoxFit.fitWidth,
  });

  final BoxFit fit;
  final String? imageUrl;
  final Clip clipBehavior;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: colors.primary, blurRadius: 16, spreadRadius: -14)],
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        clipBehavior: clipBehavior,
        borderRadius: BorderRadius.circular(100),
        child: CachedNetworkImage(
          height: size,
          width: size,

          imageUrl: imageUrl ?? '',
          imageBuilder: (_, imageProvider) {
            return DecoratedBox(
              decoration: BoxDecoration(color: colors.inverse, image: DecorationImage(image: imageProvider, fit: fit)),
            );
          },
          progressIndicatorBuilder: (_, __, ___) => const Shimmer(borderRadius: 100),
          errorWidget:
              (_, __, ___) => DecoratedBox(
                decoration: BoxDecoration(color: context.themes.main.colors.inverse, shape: BoxShape.circle),
              ),
        ),
      ),
    );
  }
}
