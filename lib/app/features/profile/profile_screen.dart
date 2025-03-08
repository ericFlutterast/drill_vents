import 'package:cached_network_image/cached_network_image.dart';
import 'package:drill_events/app/blocs/auth.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/features/widgets/app_back_button.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/app_icon_button.dart';
import 'package:drill_events/app/features/widgets/circle_avatar_decoration.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController = ScrollController();
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
    reverseDuration: const Duration(milliseconds: 1200),
  );

  @override
  void initState() {
    super.initState();

    // _scrollController.addListener(() {
    //   buttonVisibility(animationController: _animationController, scrollController: _scrollController);
    // });
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
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.isIdle && !state.hasValue) {
              context.pop();
            }
          },
          child: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPadding(padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.1)),
                  const SliverToBoxAdapter(child: _ProfileHeader()),
                  const SliverPadding(padding: EdgeInsets.only(top: 10)),
                  const SliverToBoxAdapter(child: _UserInfo()),
                  const SliverPadding(padding: EdgeInsets.only(top: 26)),
                  const _LogoutButton(),
                  const SliverPadding(padding: EdgeInsets.only(top: 35)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: Text('Вы участвуете', style: textsStyles.bodySmall),
                    ),
                  ),
                  const SliverPadding(padding: EdgeInsets.only(top: 12)),
                  SliverList.separated(
                    itemCount: 5,
                    itemBuilder:
                        (context, index) => const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: EventListItem(title: 'Винный вечер'),
                        ),
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

    return BlocBuilder<AuthBloc, CommonBlocState<UserModel>>(
      builder: (BuildContext context, state) {
        if (state.hasValue) {
          final user = state.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (user.info.name case String name) Text(name, style: textStyles.h3),
              const SizedBox(height: 5),
              if (user.info.phone case String phone) Text(phone, style: textStyles.bodySmall),
              const SizedBox(height: 5),
              Text(user.email, style: textStyles.bodySmall),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/telegram.svg'),
                  const SizedBox(width: 8),
                  Text('t.me/${user.info.telegram}', style: textStyles.bodySmall),
                ],
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 115),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.isPending) {
            return const AppButton.loading(title: 'Выйти');
          }
          return AppButton.secondary(onTap: () => context.read<AuthBloc>().add(Logout()), title: 'Выйти');
        },
      ),
    ),
  );
}

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

    return InkWell(
      onTap: onTap,
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
