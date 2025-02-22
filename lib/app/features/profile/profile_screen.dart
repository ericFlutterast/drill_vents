import 'package:drill_events/app/features/widgets/app_back_button.dart';
import 'package:drill_events/app/features/widgets/app_icon_button.dart';
import 'package:drill_events/app/features/widgets/circle_avata_decoration.dart';
import 'package:drill_events/app/features/widgets/event_list_item.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin, AnimationForBackButton {
  late final ScrollController _scrollController = ScrollController();
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
    reverseDuration: const Duration(milliseconds: 1200),
  );

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      buttonVisibility(animationController: _animationController, scrollController: _scrollController);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    final textsStyles = context.themes.main.texts;

    return Scaffold(
      backgroundColor: colors.inverse,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.1)),
                const SliverToBoxAdapter(child: _ProfileHeader()),
                const SliverPadding(padding: EdgeInsets.only(top: 10)),
                const SliverToBoxAdapter(child: _UserInfo()),
                const SliverPadding(padding: EdgeInsets.only(top: 27)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 28),
                    child: Text('Вы участвуете', style: textsStyles.bodySmall),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(top: 12)),
                SliverList.separated(
                  itemCount: 5,
                  itemBuilder: (context, index) => const EventListItem(title: 'Винный вечер'),
                  separatorBuilder: (_, __) => const SizedBox(height: 28),
                ),
                const SliverPadding(padding: EdgeInsets.only(top: 30)),
              ],
            ),
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.1,
              left: 15,
              child: SlideTransition(
                position: Tween<Offset>(begin: Offset.zero, end: const Offset(-50, 0)).animate(_animationController),
                child: AppBackButton(onTap: () => Navigator.pop(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final avatarDiameter = 100.0;
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.sizeOf(context).width / 2 - avatarDiameter / 2, right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatarDecoration(
            diameter: avatarDiameter,
            strokeWidth: 7,
            onTap: () {},
            child: Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppIconButton(icon: CupertinoIcons.pencil, onTap: () {}),
              const SizedBox(height: 13),
              AppIconButton(icon: Icons.settings, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo();

  @override
  Widget build(BuildContext context) {
    final textStyles = context.themes.main.texts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Anatoly', style: textStyles.h3),
        const SizedBox(height: 5),
        Text('anatoly_washer@gmail.com', style: textStyles.bodySmall),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/telegram.svg'),
            const SizedBox(width: 8),
            Text('t.me/@vladimirshmondenko', style: textStyles.bodySmall),
          ],
        ),
      ],
    );
  }
}
