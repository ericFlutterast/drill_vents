import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum NotificationStatus { error, success, processing }

class AppNotification extends StatefulWidget {
  const AppNotification({
    super.key,
    this.duration = const Duration(seconds: 8),
    this.status = NotificationStatus.success,
    this.title,
    this.message,
  });

  final String? title;
  final String? message;
  final Duration duration;
  final NotificationStatus status;

  @override
  State<AppNotification> createState() => _AppNotificationState();
}

class _AppNotificationState extends State<AppNotification> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: widget.duration)..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.themes.main.colors;
    final textStyles = context.themes.main.texts;

    final (icon, backgroundColor, fillColor, textColor, iconBackgroundColor) = switch (widget.status) {
      NotificationStatus.success => (
        Icons.check,
        colors.success100,
        colors.success200,
        colors.success900,
        colors.success600,
      ),
      NotificationStatus.processing => (
        CupertinoIcons.exclamationmark,
        colors.warning100,
        colors.warning200,
        colors.warning900,
        colors.warning600,
      ),
      NotificationStatus.error => (
        Icons.close_rounded,
        colors.error100,
        colors.error200,
        colors.error900,
        colors.error600,
      ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(color: backgroundColor, borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: SizeTransition(
              axis: Axis.horizontal,
              sizeFactor: Tween<double>(begin: 1, end: 0.0).animate(_animationController),
              child: Container(
                height: 63,
                decoration: BoxDecoration(color: fillColor, borderRadius: const BorderRadius.all(Radius.circular(8))),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(
                  dimension: 37,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: iconBackgroundColor, shape: BoxShape.circle),
                    child: Icon(icon, color: colors.inverse),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.title ?? 'Ошибка', style: textStyles.body.copyWith(color: textColor)),
                      const SizedBox(height: 2),
                      if (widget.message case String message)
                        Expanded(
                          child: Text(
                            message,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textStyles.caption.copyWith(color: textColor),
                          ),
                        ),
                    ],
                  ),
                ),
                const Spacer(),
                Icon(CupertinoIcons.chevron_forward, size: 24, color: textColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
