import 'package:cached_network_image/cached_network_image.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/app/ui/home/widgets/profile_progress_indicator.dart';
import 'package:drill_events/common/navigation/routes.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                readOnly: true,
                onTap: () => print('move to search page'),
                decoration: InputDecoration(
                  hintText: 'Поиск...',
                  hintStyle: context.themes.main.texts.body.copyWith(color: context.themes.main.colors.greyDark),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),

                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                ),
              ),
            ),
            const SizedBox(width: 20),
            ProfileProgressIndicator(
              onTap: () => Navigator.pushNamed(context, Routes.profile),
              child: CachedNetworkImage(
                imageUrl: '',
                errorWidget:
                    (_, __, ___) => Container(
                      height: 38,
                      width: 38,
                      decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
