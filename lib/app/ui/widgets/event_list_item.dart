import 'package:cached_network_image/cached_network_image.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

//TODO
const _items = ['Завтра', 'Surf x Post', 'English club'];

class EventListItem extends StatelessWidget {
  const EventListItem({super.key, required this.title, this.imgUrl, this.onTap}) : _showSimmer = false;

  const EventListItem.shimmer({super.key}) : _showSimmer = true, onTap = null, imgUrl = null, title = '';

  final String title;
  final String? imgUrl;
  final VoidCallback? onTap;
  final bool _showSimmer;

  @override
  Widget build(BuildContext context) {
    if (_showSimmer) return const _EventItemShimmer();

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
                  (_, __, ___) => SizedBox(
                    height: 52,
                    width: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: context.themes.main.colors.secondary, shape: BoxShape.circle),
                    ),
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

class _EventItemShimmer extends StatelessWidget {
  const _EventItemShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SizedBox(
            height: 52,
            width: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(color: context.themes.main.colors.background, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 23,
                  width: MediaQuery.sizeOf(context).width,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.themes.main.colors.background,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 23,
                  width: MediaQuery.sizeOf(context).width * 0.3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.themes.main.colors.background,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
