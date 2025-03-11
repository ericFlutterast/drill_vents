import 'package:cached_network_image/cached_network_image.dart';
import 'package:drill_events/app/blocs/detail_org.dart';
import 'package:drill_events/app/blocs/detail_org_list_section.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/app_company_logo.dart';
import 'package:drill_events/app/features/widgets/screen_header.dart';
import 'package:drill_events/app/features/widgets/shimmer.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrgScreenArgs {
  OrgScreenArgs(this.orgId);

  final String orgId;
}

class OrgScreen extends StatefulWidget {
  const OrgScreen({super.key});

  static Widget bloc(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DetailOrgBloc(context.dependencies.backendApi, context.dependencies.logger)),
        BlocProvider(
          create: (_) => DetailOrgListSectionBloc(context.dependencies.backendApi, context.dependencies.logger),
        ),
      ],
      child: const OrgScreen(),
    );
  }

  @override
  State<OrgScreen> createState() => _OrgScreenState();
}

enum _Tab { events, spots }

class _OrgScreenState extends State<OrgScreen> {
  final _scrollController = ScrollController();
  _Tab _openedTab = _Tab.events;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = context.getArgs<OrgScreenArgs>();

    context.read<DetailOrgBloc>().add(FetchDetailOrg(args.orgId));
    context.read<DetailOrgListSectionBloc>().add(FetchDetailOrgLists(args.orgId));
  }

  void _switchTab(_Tab tab) {
    setState(() => _openedTab = tab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.themes.main.colors.inverse,
      body: BlocBuilder<DetailOrgBloc, DetailOrgState>(
        builder: (context, state) {
          if (state.hasError) {
            // TODO:
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Произошла ошибка",
                            style: context.themes.main.texts.h3.copyWith(color: context.themes.main.colors.error600),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Error ${state.errorMessage}",
                            style: context.themes.main.texts.body.copyWith(color: context.themes.main.colors.error600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    AppButton.primary(title: "Назад", onTap: () => Navigator.pop(context)),
                  ],
                ),
              ),
            );
          }

          final isPending = state.isIdle || state.isPending;

          return Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(28, 82, 28, 24),
                    sliver: SliverList.list(
                      children: [
                        // TODO: добавить плавность
                        isPending
                            ? _ContentSection.shimmer()
                            : _ContentSection(
                              tab: _openedTab,
                              switchTab: _switchTab,
                              title: state.value.title,
                              description: state.value.description,
                            ),
                      ],
                    ),
                  ),
                  // TODO: постараться вынести
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: BlocBuilder<DetailOrgListSectionBloc, DetailOrgListSectionState>(
                      builder: (context, sectionState) {
                        if (sectionState.hasError) {
                          // TODO: сделать компонент ошибки для списка
                          return SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 28),
                              child: Text(
                                sectionState.errorMessage.toString(),
                                style: context.themes.main.texts.bodySmall.copyWith(
                                  color: context.themes.main.colors.error600,
                                ),
                              ),
                            ),
                          );
                        }

                        if (sectionState.isIdle || sectionState.isPending) {
                          return SliverList.list(
                            children: [
                              const Shimmer(height: 70),
                              const SizedBox(height: 20),
                              const Shimmer(height: 70),
                            ],
                          );
                        }

                        if (_openedTab == _Tab.events) {
                          final events = sectionState.value.events;

                          return SliverList.separated(
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              final event = events[index];
                              return _EventListItem(title: event.title, onTap: () => context.openEventScreen(event.id));
                            },
                            separatorBuilder: (context, index) => const SizedBox(height: 20),
                          );
                        }

                        final spots = sectionState.value.spots;

                        return SliverList.separated(
                          itemCount: spots.length,
                          itemBuilder: (context, index) {
                            final spot = spots[index];
                            // TODO: change to SpotListItem when it's ready
                            return _EventListItem(title: spot.title, onTap: () => context.openSpotScreen(spot.id));
                          },
                          separatorBuilder: (context, index) => const SizedBox(height: 20),
                        );
                      },
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
              PositionedScreenHeader(isPending: isPending, controller: _scrollController),
            ],
          );
        },
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  const _ContentSection({required this.tab, required this.title, required this.description, required this.switchTab});

  final _Tab tab;
  final String title;
  final String description;
  final Function(_Tab) switchTab;

  @override
  Widget build(BuildContext context) {
    final activeTabStyle = context.themes.main.texts.h3;
    final tabStyle = activeTabStyle.copyWith(color: context.themes.main.colors.secondary);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AppCompanyLogo(dimension: 150),
                const SizedBox(height: 24),
                Text(title, style: context.themes.main.texts.h1),
              ],
            ),
          ],
        ),
        const SizedBox(height: 28),
        // TODO: вынести в JsonConverter
        Text(description.replaceAll('\\n', '\n'), style: context.themes.main.texts.body),
        const SizedBox(height: 48),
        // TODO: create separate widget for this
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => switchTab(_Tab.events),
              child: Text("События", style: tab == _Tab.events ? activeTabStyle : tabStyle),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => switchTab(_Tab.spots),
              child: Text("Споты", style: tab == _Tab.spots ? activeTabStyle : tabStyle),
            ),
          ],
        ),
      ],
    );
  }

  static Widget shimmer() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Shimmer(height: 32, width: 260),
      const SizedBox(height: 7),
      const Shimmer(height: 21, width: 180),
      const SizedBox(height: 28),
      AppButton.shimmer(),
      const SizedBox(height: 32),
      const Shimmer(height: 25),
      const SizedBox(height: 2),
      const Shimmer(height: 25),
      const SizedBox(height: 2),
      const Shimmer(height: 25, width: 160),
      const SizedBox(height: 48),
      const Shimmer(height: 24, width: 100),
      const SizedBox(height: 24),
      const Shimmer(height: 70),
      const SizedBox(height: 20),
      const Shimmer(height: 70),
    ],
  );
}

//TODO
const _items = ['Завтра', 'Surf x Post', 'English club'];

class _EventListItem extends StatelessWidget {
  const _EventListItem({super.key, required this.title, this.imgUrl, this.onTap}) : _showSimmer = false;

  const _EventListItem.shimmer({super.key}) : _showSimmer = true, onTap = null, imgUrl = null, title = '';

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
