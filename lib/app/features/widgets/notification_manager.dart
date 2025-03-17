import 'dart:async';

import 'package:flutter/material.dart';

class NotificationManager extends StatefulWidget {
  const NotificationManager({super.key, required this.child});

  final Widget child;

  static NotificationManagerState? maybeOf(BuildContext context, {listen = false}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<_AppNotificationInheritedScope>()?.state;
    } else {
      final inheritedWidget = context.getElementForInheritedWidgetOfExactType<_AppNotificationInheritedScope>()?.widget;
      return (inheritedWidget as _AppNotificationInheritedScope?)?.state;
    }
  }

  static NotificationManagerState of(BuildContext context, {listen = false}) {
    final result = maybeOf(context, listen: listen);
    assert(result != null, "_AppNotificationState does not contains in this context");
    return result!;
  }

  @override
  State<NotificationManager> createState() => NotificationManagerState();
}

class NotificationManagerState extends State<NotificationManager> with SingleTickerProviderStateMixin {
  bool _isShow = false;
  Timer? _timer;
  Widget? _notification;

  Duration get defaultNotificationDuration => const Duration(seconds: 5);

  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );
  }

  void showNotification({Widget? notification, Duration? duration}) {
    final timerDuration = duration ?? defaultNotificationDuration;
    setState(() {
      _notification = notification;
      _isShow = true;
    });
    _animationController.forward(from: _animationController.lowerBound);
    _timer = Timer(timerDuration, () => closeNotification());
  }

  Future<void> closeNotification() async {
    _cancelTimer();
    await _animationController.reverse();
    setState(() => _isShow = false);
  }

  @override
  void dispose() {
    _cancelTimer();
    _animationController.dispose();
    super.dispose();
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return _AppNotificationInheritedScope(
      state: this,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          widget.child,
          if (_isShow)
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.05,
              left: 0,
              right: 0,
              height: 63,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, -5), end: Offset.zero).animate(_animationController),
                child: Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.vertical,
                  onDismissed: (_) => closeNotification(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Material(color: Colors.transparent, child: _notification ?? const SizedBox.shrink()),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

final class _AppNotificationInheritedScope extends InheritedWidget {
  const _AppNotificationInheritedScope({required super.child, required this.state});

  final NotificationManagerState state;

  @override
  bool updateShouldNotify(covariant _AppNotificationInheritedScope oldWidget) =>
      !identical(oldWidget.state, state) || state != oldWidget.state;
}
