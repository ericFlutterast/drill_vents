import 'package:cached_network_image/cached_network_image.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

class SpotsTile extends StatefulWidget {
  const SpotsTile({super.key});

  @override
  State<SpotsTile> createState() => _SpotsTileState();
}

class _SpotsTileState extends State<SpotsTile> {
  int? _selectedIndex;

  void _selectSpot(int index) {
    if (index == _selectedIndex) {
      setState(() => _selectedIndex = null);
      return;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Опубликовать в', style: texts.body.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        for (final (index, item) in [1, 2, 3, 4].indexed) ...[
          _Spot(onSelect: () => _selectSpot(index), isSelect: _selectedIndex == index),
          if (index != 3) const SizedBox(height: 20),
        ],
      ],
    );
  }
}

class _Spot extends StatelessWidget {
  const _Spot({required this.onSelect, this.isSelect = false});

  final VoidCallback onSelect;
  final bool isSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    final texts = context.themes.main.texts;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: '',
          errorWidget:
              (_, __, ___) => Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(color: colors.secondary, shape: BoxShape.circle),
              ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Surf x Post', style: texts.bodySmall.copyWith(fontWeight: FontWeight.w600, height: 1.3)),
              const SizedBox(height: 4),
              Text('Краснодар, Мира 366', style: texts.bodySmall),
            ],
          ),
        ),
        _SelectSpotButton(onTap: onSelect, isSelect: isSelect),
      ],
    );
  }
}

class _SelectSpotButton extends StatelessWidget {
  const _SelectSpotButton({required this.onTap, required this.isSelect});

  final VoidCallback onTap;
  final bool isSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;

    return GestureDetector(
      onTap: onTap,
      child:
          isSelect
              ? SizedBox.square(
                dimension: 36,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
                  child: Icon(Icons.check_outlined, color: colors.inverse, size: 18),
                ),
              )
              : SizedBox.square(
                dimension: 36,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                  ),
                ),
              ),
    );
  }
}
