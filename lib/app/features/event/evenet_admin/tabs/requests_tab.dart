part of '../event_admin_screen.dart';

class _RequestsTab extends StatefulWidget {
  const _RequestsTab();

  @override
  State<_RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<_RequestsTab> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ModerationUsersBloc, ModerationUsersState>(
      listener: (_, state) {
        if (state.isError) {
          NotificationManager.of(context).showNotification(
            notification: AppNotification(message: state.errorMessage.toString(), status: NotificationStatus.error),
          );
        }
      },
      builder: (context, state) {
        if (state.hasValue && state.isDone || state.isError) {
          return CustomScrollView(
            controller: PrimaryScrollController.of(context),
            slivers: [
              const SliverPadding(padding: EdgeInsets.only(top: 140)),
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: _RequestsTabHeaderDelegate(usersLength: state.value.length),
              ),
              if (state.value.isEmpty) ...[
                const SliverPadding(padding: EdgeInsets.only(top: 120)),
                const _NoRequests(),
              ] else
                SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 24),
                    for (final (i, item) in state.value.indexed) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _RequestItem(
                          key: ValueKey(item.id),
                          onTransitionAnimation: i == 0,
                          name: item.name,
                          email: item.email,
                          userId: item.id,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ]),
                ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

final class _RequestsTabHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _RequestsTabHeaderDelegate({required this.usersLength});

  final int usersLength;

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final texts = context.themes.main.texts;
    final colors = context.themes.main.colors;

    return ColoredBox(
      color: colors.inverse,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Заявки', style: texts.h1),
              Text('Осталось: $usersLength', style: texts.h3.copyWith(color: colors.secondary)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_RequestsTabHeaderDelegate oldDelegate) => oldDelegate.usersLength != usersLength;
}

class _RequestItem extends StatefulWidget {
  const _RequestItem({
    super.key,
    this.onTransitionAnimation = false,
    required this.name,
    required this.email,
    required this.userId,
  });

  final bool onTransitionAnimation;
  final String email;
  final String userId;
  final String? name;

  @override
  State<_RequestItem> createState() => _RequestItemState();
}

class _RequestItemState extends State<_RequestItem> {
  double primaryDelta = 0.0;
  Offset _position = Offset.zero;
  double _angel = 0.0;
  double _lerpDeclineButton = 0.0;
  double _lerpAproveButton = 0.0;

  void _onPanUpdate(DragUpdateDetails detail) {
    setState(() {
      _position += detail.delta;
    });
    _checkCursorPointerOffset(detail.delta.dx);
    _checkWhenDeleteItemRight(detail.globalPosition.dx, detail.globalPosition.dy);
    _checkWhenDeleteItemLeft(detail.globalPosition.dx, detail.globalPosition.dy);
  }

  void _checkCursorPointerOffset(double deltaX) {
    if (deltaX > 0) {
      if (_lerpAproveButton < 1) {
        _lerpDeclineButton = 0.0;
        setState(() => _lerpAproveButton += deltaX / 250);
      }
    } else {
      if (_lerpDeclineButton < 1) {
        _lerpAproveButton = 0.0;
        setState(() => _lerpDeclineButton -= deltaX / 250);
      }
    }
  }

  void _checkWhenDeleteItemRight(double dx, dy) {
    if (dx > 350) {
      setState(() {
        _position = Offset(0, dy * 2);
        _angel = 20;
      });

      _approveUser();
    }
  }

  void _approveUser() {
    final eventId = context.getArgs<EventScreenArgs>().eventId;
    context.read<ModerationUsersBloc>().add(ApproveUserEvent(eventId, userId: widget.userId));
  }

  void _checkWhenDeleteItemLeft(double dx, dy) {
    if (dx < 20) {
      setState(() {
        _position = Offset(0, dy * 2);
        _angel = -20;
      });

      _declineUser();
    }
  }

  void _declineUser() {
    final eventId = context.getArgs<EventScreenArgs>().eventId;
    context.read<ModerationUsersBloc>().add(DeclineUserEvent(eventId, userId: widget.userId));
  }

  void _onPanEnd(DragEndDetails _) => setState(() {
    _position = Offset.zero;
    _lerpDeclineButton = 0.0;
    _lerpAproveButton = 0.0;
  });

  void _onTapUp(TapUpDetails _) => setState(() {
    _position = Offset.zero;
    _lerpDeclineButton = 0.0;
    _lerpAproveButton = 0.0;
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    final texts = context.themes.main.texts;

    final contentItem = DecoratedBox(
      decoration: BoxDecoration(color: colors.primary, borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _UserInfoRequestItem(name: widget.name, email: widget.email),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppButton.custom(
                    title: 'Отклонить',
                    onTap: _declineUser,
                    backgroundColor: Color.lerp(colors.error200, colors.error600, _lerpDeclineButton),
                    titleStyle: texts.body.copyWith(
                      color: Color.lerp(colors.error600, colors.error900, _lerpDeclineButton),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton.custom(
                    title: 'Принять',
                    onTap: _approveUser,
                    backgroundColor: Color.lerp(colors.success200, colors.success600, _lerpAproveButton),
                    titleStyle: texts.body.copyWith(
                      color: Color.lerp(colors.success600, colors.success900, _lerpAproveButton),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (!widget.onTransitionAnimation) return contentItem;

    return LayoutBuilder(
      builder: (context, constraints) {
        final center = constraints.smallest.center(Offset.zero);
        _angel = 45 * _position.dx / constraints.maxWidth * pi / 180;
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          onTapUp: _onTapUp,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            transform:
                Matrix4.identity()
                  ..translate(center.dx, center.dy)
                  ..rotateZ(_angel)
                  ..translate(-center.dx, -center.dy)
                  ..translate(_position.dx, _position.dy),
            child: contentItem,
          ),
        );
      },
    );
  }
}

class _UserInfoRequestItem extends StatelessWidget {
  const _UserInfoRequestItem({required this.name, required this.email});

  final String? name;
  final String email;

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    final texts = context.themes.main.texts;

    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), color: colors.inverse),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            SizedBox.square(
              child: DecoratedBox(
                decoration: BoxDecoration(color: colors.secondary, borderRadius: BorderRadius.circular(100)),
                child: const SizedBox.square(dimension: 52),
              ),
            ),
            const SizedBox(width: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [if (name != null) Text(name!, style: texts.h3), Text(email)],
            ),
          ],
        ),
      ),
    );
  }
}

class _NoRequests extends StatelessWidget {
  const _NoRequests();

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    final texts = context.themes.main.texts;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox.square(
                dimension: 37,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: colors.success600, shape: BoxShape.circle),
                  child: Icon(Icons.check_outlined, color: colors.inverse),
                ),
              ),
              const SizedBox(height: 12),
              Text('Вы рассмотрели все запросы', textAlign: TextAlign.center, style: texts.h2),
              const SizedBox(height: 6),
              Text('Пока новых запросов нет', textAlign: TextAlign.center, style: texts.body),
            ],
          ),
        ),
      ),
    );
  }
}
