import 'package:cached_network_image/cached_network_image.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/blocs/events/bloc.dart';
import 'package:drill_events/app/blocs/events/events.dart';
import 'package:drill_events/app/features/widgets/animated_refresh.dart';
import 'package:drill_events/app/features/widgets/app_text_field.dart';
import 'package:drill_events/app/features/widgets/circle_avata_decoration.dart';
import 'package:drill_events/app/features/widgets/event_list_item.dart';
import 'package:drill_events/app/models/event_model.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/navigation/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: BlocBuilder<EventsBloc, CommonBlocState<Iterable<EventModel>>>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  collapsedHeight: MediaQuery.sizeOf(context).height * 0.1,
                  surfaceTintColor: context.themes.main.colors.inverse,
                  backgroundColor: context.themes.main.colors.inverse,
                  expandedHeight: 120,
                  pinned: true,
                  flexibleSpace: const FlexibleSpaceBar(
                    expandedTitleScale: 1,
                    title: _HomeHeader(),
                    titlePadding: EdgeInsets.only(bottom: 10),
                  ),
                ),
                CupertinoSliverRefreshControl(
                  refreshIndicatorExtent: 60,
                  refreshTriggerPullDistance: 120,
                  onRefresh: () async => context.read<EventsBloc>().add(FetchEventsFeed()),
                  builder: (context, _, __, ___, ____) {
                    return const Center(child: AnimatedRefresh());
                  },
                ),
                const _SoonEventsTitle(),

                if (state.isPending)
                  SliverList.separated(
                    itemCount: 10, //state.value.length,
                    itemBuilder: (context, index) => const EventListItem.shimmer(),
                    separatorBuilder: (_, __) => const SizedBox(height: 28),
                  ),

                // if (state.hasValue && state.value.isEmpty || state.hasError)
                //   SliverToBoxAdapter(
                //     child: Center(
                //       child: Padding(
                //         padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.2),
                //         child: Text('Не удалось загрузить', style: context.themes.main.texts.body),
                //       ),
                //     ),
                //   )
                // else if (state.hasValue)
                SliverList.separated(
                  itemCount: 10, //state.value.length,
                  itemBuilder:
                      (context, index) => EventListItem(
                        title: 'Вечеринка для поддержания семеных отношений', //state.value.elementAt(index).title,
                        onTap: () => Navigator.pushNamed(context, Routes.event),
                      ),
                  separatorBuilder: (_, __) => const SizedBox(height: 28),
                ),
                const SliverPadding(padding: EdgeInsets.only(top: 30)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AppTextField(
              hintText: 'Поиск...',
              onChanged: (value) {
                if (value.isEmpty) {
                  context.read<EventsBloc>().add(FetchEventsFeed());
                } else {
                  context.read<EventsBloc>().add(SearchEvents(value: value));
                }
              },
            ),
          ),
          const SizedBox(width: 20),
          CircleAvatarDecoration(
            onTap: () => Navigator.pushNamed(context, Routes.profile),
            child: SizedBox(
              height: 38,
              width: 38,
              child: CachedNetworkImage(
                imageUrl: '',
                errorWidget:
                    (_, __, ___) => const SizedBox(
                      height: 38,
                      width: 38,
                      child: DecoratedBox(decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle)),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoonEventsTitle extends StatelessWidget {
  const _SoonEventsTitle();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 35, 28, 28),
        child: Text('Ближайшие события', style: context.themes.main.texts.body),
      ),
    );
  }
}
