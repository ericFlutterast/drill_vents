part of '../event_admin_screen.dart';

class _DetailEventTab extends StatelessWidget {
  const _DetailEventTab({this.onShowParticipants, this.onShowRequests});

  final VoidCallback? onShowParticipants;
  final VoidCallback? onShowRequests;

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;
    final colors = context.themes.main.colors;

    return BlocBuilder<EventDetailAdminBloc, EventDetailAdminState>(
      builder: (context, state) {
        if (state.isPending) return EventAdminScreen.shimmer(context);

        if (state.hasValue && state.isDone) {
          return TabBuilder(
            builder: (context) {
              return CustomScrollView(
                controller: PrimaryScrollController.of(context),
                slivers: [
                  const SliverPadding(padding: EdgeInsets.only(top: 180)),
                  SliverToBoxAdapter(
                    child: _ContentSection(
                      onTapOrgName: () => context.openOrgScreen(state.value.event.org.id),
                      onTapSpotName: () => context.openSpotScreen(state.value.event.spot.id),
                      eventName: state.value.event.title,
                      description: state.value.event.description,
                      orgName: state.value.event.org.title,
                      spotName: state.value.event.spot.title,
                      startTime: state.value.event.startTime,
                      startDate: state.value.event.startDate,
                      address: '${state.value.event.spotCity ?? ''}, ${state.value.event.spot.address}',
                    ),
                  ),
                  const SliverPadding(padding: EdgeInsets.only(top: 24)),
                  if (state.value.participants.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Участники ',
                                style: texts.body.copyWith(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: '(${state.value.participants.length}/${state.value.event.capacity})',
                                    style: texts.body.copyWith(fontWeight: FontWeight.bold, color: colors.secondary),
                                  ),
                                ],
                              ),
                            ),
                            AppButton.secondary(
                              title: 'Показать всех',
                              onTap: onShowParticipants,
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverPadding(padding: EdgeInsets.only(top: 16)),
                    SliverList.separated(
                      itemCount: state.value.participants.length,
                      itemBuilder: (context, index) {
                        final participant = state.value.participants.elementAt(index);

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _UserListItem(name: participant.name ?? '', mail: participant.email),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                    ),
                  ],
                  SliverToBoxAdapter(
                    child: BlocBuilder<ModerationUsersBloc, ModerationUsersState>(
                      builder: (context, state) {
                        if (state.hasValue && state.value.isNotEmpty) {
                          return Column(
                            children: [
                              const SizedBox(height: 24),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: AppButton.primary(onTap: onShowRequests, title: 'Рассмотреть заявки'),
                              ),
                            ],
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),

                  const SliverPadding(padding: EdgeInsets.only(top: 30)),
                ],
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _ContentSection extends StatelessWidget {
  const _ContentSection({
    required this.eventName,
    required this.description,
    required this.orgName,
    required this.spotName,
    required this.startTime,
    required this.startDate,
    required this.address,
    this.onTapOrgName,
    this.onTapSpotName,
  });

  final VoidCallback? onTapOrgName, onTapSpotName;
  final String eventName, spotName, orgName, description, address, startDate, startTime;

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (orgName.isNotEmpty && spotName.isNotEmpty)
            Row(
              children: [
                GestureDetector(onTap: onTapOrgName, child: Text(orgName, style: texts.bodySmall)),
                const SizedBox(width: 8),
                const Interpunct(),
                const SizedBox(width: 8),
                GestureDetector(onTap: onTapSpotName, child: Text(spotName, style: texts.bodySmall)),
              ],
            ),
          const SizedBox(height: 7),
          Text(eventName, style: texts.h1),
          const SizedBox(height: 38),
          DateTimeInfo(address: address, startTime: startTime, date: startDate),
          const SizedBox(height: 32),
          Text(description, style: texts.body),
        ],
      ),
    );
  }
}
