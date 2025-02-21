import 'package:cached_network_image/cached_network_image.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

//TODO
const _items = ['Завтра', 'Surf x Post', 'English club'];

class EventListItem extends StatelessWidget {
  const EventListItem({super.key, required this.title, this.imgUrl, this.onTap});

  final String title;
  final String? imgUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: '',
              errorWidget:
                  (_, __, ___) => Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(color: context.themes.main.colors.secondary, shape: BoxShape.circle),
                  ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.themes.main.texts.body.copyWith(fontWeight: FontWeight.w600, height: 1.3)),
                  const SizedBox(height: 8),
                  Wrap(
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      for (final (i, item) in _items.indexed) ...[
                        Text(item, style: context.themes.main.texts.bodySmall),
                        if (i != _items.length - 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7.5),
                            child: SizedBox.square(
                              dimension: 5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: context.themes.main.colors.secondary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
