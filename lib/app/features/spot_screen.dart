import 'package:drill_events/app/blocs/detail_spot.dart';
import 'package:drill_events/app/blocs/detail_spot_list_section.dart';
import 'package:drill_events/app/features/widgets/app_button.dart';
import 'package:drill_events/app/features/widgets/event_list_item.dart';
import 'package:drill_events/app/features/widgets/screen_header.dart';
import 'package:drill_events/app/features/widgets/shimmer.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:drill_events/common/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpotScreenArgs {
  SpotScreenArgs(this.spotId);

  final String spotId;
}

class SpotScreen extends StatefulWidget {
  const SpotScreen({super.key});

  static Widget bloc(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DetailSpotBloc(context.dependencies.backendApi, context.dependencies.logger)),
        BlocProvider(
          create: (_) => DetailSpotListSectionBloc(context.dependencies.backendApi, context.dependencies.logger),
        ),
      ],
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

    context.read<DetailSpotBloc>().add(FetchDetailSpot(args.spotId));
    context.read<DetailSpotListSectionBloc>().add(FetchDetailSpotEvents(args.spotId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.themes.main.colors.inverse,
      body: BlocBuilder<DetailSpotBloc, DetailSpotState>(
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
                    padding: const EdgeInsets.fromLTRB(28, 180, 28, 24),
                    sliver: SliverList.list(
                      children: [
                        // TODO: добавить плавность
                        isPending
                            ? _ContentSection.shimmer()
                            : _ContentSection(
                              title: state.value.title,
                              description: state.value.description,
                              address: state.value.address,
                              subscribed: false,
                              onSubscribe: () {},
                            ),
                      ],
                    ),
                  ),
                  // TODO: вынести
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: BlocBuilder<DetailSpotListSectionBloc, DetailSpotListSectionState>(
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

                        final events = sectionState.value;

                        return SliverList.separated(
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];
                            return EventListItem(title: event.title, onTap: () => context.openEventScreen(event.id));
                          },
                          separatorBuilder: (context, index) => const SizedBox(height: 20),
                        );
                      },
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
              // TODO:
              PositionedScreenHeader(
                isPending: isPending,
                controller: _scrollController,
                onTapLogo: () => context.openOrgScreen(state.value.org.id),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  const _ContentSection({
    required this.title,
    required this.address,
    required this.description,
    required this.subscribed,
    this.onSubscribe,
  });

  final String title;
  final String address;
  final String description;
  final bool subscribed;
  final VoidCallback? onSubscribe;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.themes.main.texts.h1),
        const SizedBox(height: 7),
        Text(address, style: context.themes.main.texts.bodySmall),
        const SizedBox(height: 28),
        AppButton.primary(title: "Подписаться", onTap: onSubscribe),
        const SizedBox(height: 32),
        // TODO: вынести в JsonConverter
        Text(description.replaceAll('\\n', '\n'), style: context.themes.main.texts.body),
        const SizedBox(height: 48),
        Text("События", style: context.themes.main.texts.h3),
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
    ],
  );
}
