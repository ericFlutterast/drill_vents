import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(100)),
      onTap: onTap,
      child: SizedBox.square(
        dimension: 42,
        child: Ink(
          decoration: BoxDecoration(color: context.themes.main.colors.background, shape: BoxShape.circle),
          child: const Icon(Icons.arrow_back, size: 24),
        ),
      ),
    );
  }
}

// TODO: remove
mixin AnimationForBackButton<T extends StatefulWidget> on State<T> {
  bool isShowBackButton = true;

  void buttonVisibility({
    required AnimationController animationController,
    required ScrollController scrollController,
  }) {
    final offset = scrollController.offset;
    final userScroll = scrollController.position.userScrollDirection;

    if (offset > 60 && userScroll == ScrollDirection.reverse && isShowBackButton) {
      animationController.forward();
      setState(() => isShowBackButton = false);
      return;
    }

    if (offset < 150 && userScroll == ScrollDirection.forward && !isShowBackButton) {
      animationController.reverse();
      setState(() => isShowBackButton = true);
      return;
    }

    if (offset == 0) {
      animationController.reverse();
      setState(() => isShowBackButton = true);
      return;
    }
  }
}
