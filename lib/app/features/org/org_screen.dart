import 'package:drill_events/app/blocs/detail_org_bloc.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/app_company_logo.dart';
import 'package:drill_events/app/features/widgets/event_list_item.dart';
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
    return BlocProvider<DetailOrgBloc>(
      create: (_) => DetailOrgBloc(context.dependencies.repository, context.dependencies.logger),
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

    final bloc = context.read<DetailOrgBloc>();
    bloc.add(FetchDetailOrgEvent(args.orgId));
  }

  void _onTapSpot(String spotID) {
    context.openSpotScreen(spotID);
  }

  void _onTapEvent(String eventID) {
    context.openEventScreen(eventID);
  }

  void _switchTab(_Tab tab) {
    setState(() => _openedTab = tab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.themes.main.colors.inverse,
      body: BlocBuilder<DetailOrgBloc, DetailOrgBlocState>(
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
                    AppButton(title: "Назад", onTap: () => Navigator.pop(context)),
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
                  if (!isPending)
                    // TODO: refactor
                    if (_openedTab == _Tab.events)
                      SliverList.separated(
                        itemCount: state.value.events.length,
                        itemBuilder: (context, index) {
                          final event = state.value.events[index];
                          return EventListItem(title: event.title, onTap: () => _onTapEvent(event.eventId));
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 20),
                      )
                    else
                      SliverList.separated(
                        itemCount: state.value.spots.length,
                        itemBuilder: (context, index) {
                          final spot = state.value.spots[index];
                          // TODO: change to SpotListItem when it's ready
                          return EventListItem(title: spot.title, onTap: () => _onTapSpot(spot.id));
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 20),
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
