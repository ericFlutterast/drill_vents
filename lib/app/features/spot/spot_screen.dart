import 'package:drill_events/app/blocs/detail_spot_bloc.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/event_list_item.dart';
import 'package:drill_events/app/features/widgets/screen_header.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/navigation/routes.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpotScreenArgs {
  SpotScreenArgs(this.spotId);

  final String spotId;
}

class SpotScreen extends StatefulWidget {
  const SpotScreen({super.key});

  static Widget bloc(BuildContext context) {
    return BlocProvider<DetailSpotBloc>(
      create: (_) => DetailSpotBloc(context.dependencies.repository, context.dependencies.logger),
      child: const SpotScreen(),
    );
  }

  @override
  State<SpotScreen> createState() => _SpotScreenState();
}

class _SpotScreenState extends State<SpotScreen> {
  final _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = context.getArgs<SpotScreenArgs>();

    final bloc = context.read<DetailSpotBloc>();
    bloc.add(FetchDetailSpotEvent(args.spotId));
  }

  void _onTapLogo() {
    Navigator.pushNamed(context, Routes.org);
  }

  void _onTapSubscribe() {}

  void _onTapEvent(String eventID) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.themes.main.colors.inverse,
      body: Stack(
        children: [
          BlocBuilder<DetailSpotBloc, DetailSpotBlocState>(
            builder: (context, state) {
              if (state.hasError) {
                // TODO:
                return Expanded(child: Text("Error ${state.errorMessage}"));
              }

              if (state.isPending) {
                // TODO:
                return const Text("Pending");
              }

              if (state.isIdle) {
                // TODO:
                return const Text("Idle");
              }

              final spot = state.value;

              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(28, 180, 28, 24),
                    sliver: SliverList.list(
                      children: [
                        Text(spot.title, style: context.themes.main.texts.h1),
                        const SizedBox(height: 7),
                        Text(spot.address, style: context.themes.main.texts.bodySmall),
                        const SizedBox(height: 28),
                        AppButton(title: "Подписаться", onTap: _onTapSubscribe),
                        const SizedBox(height: 32),
                        // TODO: вынести в JsonConverter
                        Text(spot.description.replaceAll('\\n', '\n'), style: context.themes.main.texts.body),
                        const SizedBox(height: 48),
                        Text("События", style: context.themes.main.texts.h3),
                      ],
                    ),
                  ),
                  SliverList.separated(
                    itemCount: spot.events.length,
                    itemBuilder: (context, index) {
                      final event = spot.events[index];
                      return EventListItem(title: event.title, onTap: () => _onTapEvent(event.eventId));
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 20),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              );
            },
          ),
          PositionedScreenHeader(controller: _scrollController, onTapLogo: _onTapLogo),
        ],
      ),
    );
  }
}
