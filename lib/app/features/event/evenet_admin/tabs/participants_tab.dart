part of '../event_admin_screen.dart';

class _ParticipantsListTab extends StatelessWidget {
  const _ParticipantsListTab();

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;
    final colors = context.themes.main.colors;

    final (capacity, participants) = context.select<EventDetailAdminBloc, (int, Iterable<ShortUserModel>)>((bloc) {
      final state = bloc.state.getValueOrNull;
      return (state?.event.capacity ?? 0, state?.participants ?? []);
    });

    return TabBuilder(
      builder: (context) {
        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: PrimaryScrollController.of(context),
          slivers: [
            const SliverPadding(padding: EdgeInsets.only(top: 180)),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    children: [
                      Text('Участники ', style: texts.h1),
                      Text('(${participants.length}/$capacity)', style: texts.h3.copyWith(color: colors.secondary)),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                for (final item in participants) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _UserListItem(name: item.name ?? '', mail: item.email, imageUrl: item.imageUrl),
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 28),
              ]),
            ),
          ],
        );
      },
    );
  }
}
