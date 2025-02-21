import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ParticipationNotificationStatus { decline, success, processing }

class ParticipationNotification extends StatefulWidget {
  const ParticipationNotification({
    super.key,
    this.duration = const Duration(seconds: 8),
    this.status = ParticipationNotificationStatus.success,
  });

  final Duration duration;
  final ParticipationNotificationStatus status;

  @override
  State<ParticipationNotification> createState() => _ParticipationNotificationState();
}

class _ParticipationNotificationState extends State<ParticipationNotification> with SingleTickerProviderStateMixin {
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
      ParticipationNotificationStatus.success => (
        Icons.check,
        colors.successBackground,
        colors.successBackgroundAccent,
        colors.successAccent,
        colors.successText,
      ),
      ParticipationNotificationStatus.processing => (
        CupertinoIcons.exclamationmark,
        colors.amberBackground,
        colors.amberBackgroundAccent,
        const Color(0xFFB54708),
        colors.amberText,
      ),
      ParticipationNotificationStatus.decline => (
        Icons.close_rounded,
        colors.errorBackground,
        colors.errorBackgroundAccent,
        colors.errorAccent,
        colors.errorText,
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
              children: [
                SizedBox.square(
                  dimension: 37,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: iconBackgroundColor, shape: BoxShape.circle),
                    child: Icon(icon, color: colors.background),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Surf x Post', style: textStyles.body.copyWith(color: textColor)),
                    const SizedBox(height: 2),
                    Text('Ваша заявка на участие отклонена', style: textStyles.caption.copyWith(color: textColor)),
                  ],
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
