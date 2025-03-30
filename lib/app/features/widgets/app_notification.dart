import 'package:drill_events/app/features/widgets/notification_manager.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum NotificationStatus { error, success, processing }

class AppNotification extends StatefulWidget {
  const AppNotification({super.key, this.duration, this.status = NotificationStatus.success, this.title, this.message});

  final String? title;
  final String? message;
  final Duration? duration;
  final NotificationStatus status;

  @override
  State<AppNotification> createState() => _AppNotificationState();
}

class _AppNotificationState extends State<AppNotification> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final _AppContentSettings _contentSettings;
  final double _verticalPadding = 10;

  @override
  void initState() {
    super.initState();
    final duration = NotificationManager.of(context).defaultNotificationDuration;
    _animationController = AnimationController(vsync: this, duration: duration)..forward();
    _contentSettings = _getContentSettings();
  }

  _AppContentSettings _getContentSettings() {
    final colors = context.themes.main.colors;
    return switch (widget.status) {
      NotificationStatus.success => _AppContentSettings(
        icon: Icons.check,
        textColor: colors.success900,
        backgroundColor: colors.success100,
        fillColor: colors.success200,
        iconBackgroundColor: colors.success600,
      ),
      NotificationStatus.processing => _AppContentSettings(
        icon: CupertinoIcons.exclamationmark,
        backgroundColor: colors.warning100,
        fillColor: colors.warning200,
        textColor: colors.warning900,
        iconBackgroundColor: colors.warning600,
      ),
      NotificationStatus.error => _AppContentSettings(
        icon: Icons.close_rounded,
        backgroundColor: colors.error100,
        fillColor: colors.error200,
        textColor: colors.error900,
        iconBackgroundColor: colors.error600,
      ),
    };
  }

  double _calculateTextHeight(double maxSize) {
    final titleStyle = context.themes.main.texts.body;
    final titleTextPainter = TextPainter(
      text: TextSpan(text: widget.title, style: titleStyle),
      textDirection: TextDirection.ltr,
    );
    titleTextPainter.layout();
    final titleHeight = titleTextPainter.size.height;

    final messageStyle = context.themes.main.texts.caption;
    final messageTextPinter = TextPainter(
      maxLines: 2,
      text: TextSpan(text: widget.message, style: messageStyle),
      textDirection: TextDirection.ltr,
    );
    messageTextPinter.layout(maxWidth: maxSize);
    final messageHeight = messageTextPinter.size.height;

    return messageHeight + titleHeight;
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

    return LayoutBuilder(
      builder: (context, constrains) {
        final height = _calculateTextHeight(constrains.maxWidth * 0.4);

        return SizedBox(
          height: height + _verticalPadding * 2,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _contentSettings.backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
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
                      height: height + _verticalPadding * 2,
                      decoration: BoxDecoration(
                        color: _contentSettings.fillColor,
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: _verticalPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox.square(
                        dimension: 37,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: _contentSettings.iconBackgroundColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_contentSettings.icon, color: colors.inverse),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title ?? 'Ошибка',
                              style: context.themes.main.texts.body.copyWith(color: _contentSettings.textColor),
                            ),

                            if (widget.message case String message) ...[
                              const SizedBox(height: 2),
                              Expanded(
                                child: Text(
                                  message,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyles.caption.copyWith(color: _contentSettings.textColor),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Spacer(flex: 1),
                      Flexible(
                        flex: 1,
                        child: Icon(CupertinoIcons.chevron_forward, size: 24, color: _contentSettings.textColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

final class _AppContentSettings {
  const _AppContentSettings({
    required this.icon,
    required this.textColor,
    required this.backgroundColor,
    required this.fillColor,
    required this.iconBackgroundColor,
  });

  final Color backgroundColor;
  final Color fillColor;
  final Color textColor;
  final Color iconBackgroundColor;
  final IconData icon;
}
