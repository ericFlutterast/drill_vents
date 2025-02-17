import 'package:drill_events/app/themes/app_themes.dart';
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
                  fillColor: Color(0xFFF5F5F5),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                ),
              ),
            ),
            SizedBox(width: 20),
            Container(height: 48, width: 48, decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
          ],
        ),
      ),
    );
  }
}
