import 'dart:async';

import 'package:drill_events/app/blocs/auth/bloc.dart';
import 'package:drill_events/app/blocs/auth/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final _duration = const Duration(seconds: 2);
  final _reverseDuration = const Duration(seconds: 2);

  bool _isShow = false;
  Timer? _timer;
  Widget? _notification;

  late final AnimationController _animationController;

  //TODO:
  bool useColor = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _duration, reverseDuration: _reverseDuration);
  }

  void showNotification({Widget? notification, Duration duration = const Duration(seconds: 4)}) {
    final timerDuration = duration + _duration * 2;
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
                position: Tween<Offset>(begin: const Offset(0, -50), end: Offset.zero).animate(_animationController),
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
          //TODO: убрать когда будет готова авторизация
          Positioned(
            right: 10,
            bottom: 50,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: useColor ? WidgetStateProperty.all(Colors.green) : null),
              onPressed: () async {
                final shared = await SharedPreferences.getInstance();
                if (shared.getString('uid') != null) {
                  shared.remove('uid');
                  setState(() => useColor = false);
                } else {
                  shared.setString('uid', '972d4ea4-93f2-48ec-b121-9306d56e4aca');
                  setState(() => useColor = true);
                  context.read<AuthBloc>().add(GetJwtTokenEvent());
                }
              },
              child: const Text('Use user'),
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
