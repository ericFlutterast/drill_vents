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
                    child: _UserListItem(title: item.name ?? '', mail: item.email),
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

class _UserListItem extends StatelessWidget {
  const _UserListItem({required this.title, required this.mail});

  final String title, mail;

  static Widget shimmer() {
    return const Row(
      children: [
        Shimmer(borderRadius: 100, height: 52, width: 52),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Shimmer(height: 18, width: 200), SizedBox(width: 3), Shimmer(height: 18, width: 150)],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.themes.main.texts;
    final colors = context.themes.main.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(height: 52, width: 52, decoration: BoxDecoration(color: colors.secondary, shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: texts.body.copyWith(fontWeight: FontWeight.w600, height: 1.3),
              ),

              Text(mail, maxLines: 2, overflow: TextOverflow.ellipsis, style: texts.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
