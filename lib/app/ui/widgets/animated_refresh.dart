import 'dart:math';

import 'package:drill_events/app/generated/assets.gen.dart';
import 'package:flutter/material.dart';

class AnimatedRefresh extends StatefulWidget {
  const AnimatedRefresh({super.key});

  @override
  State<AnimatedRefresh> createState() => _AnimatedRefState();
}

class _AnimatedRefState extends State<AnimatedRefresh> with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))
    ..repeat();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AnimatedRefresh(controller: _animationController);
  }
}

class _AnimatedRefresh extends AnimatedWidget {
  const _AnimatedRefresh({super.key, required AnimationController controller}) : super(listenable: controller);

  Animation<double> get _progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(angle: _progress.value * -pi, child: Assets.icons.refresh.svg());
  }
}
