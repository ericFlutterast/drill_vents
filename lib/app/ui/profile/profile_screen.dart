import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/app/ui/profile/widgets/profile_header.dart';
import 'package:drill_events/app/ui/profile/widgets/user_info.dart';
import 'package:drill_events/app/ui/widgets/app_back_button.dart';
import 'package:drill_events/app/ui/widgets/event_list_item.dart';
import 'package:flutter/material.dart';

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
                const SliverToBoxAdapter(child: ProfileHeader()),
                const SliverPadding(padding: EdgeInsets.only(top: 10)),
                const SliverToBoxAdapter(child: UserInfo()),
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
