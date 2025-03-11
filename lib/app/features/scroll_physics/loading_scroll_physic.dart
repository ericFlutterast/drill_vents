import 'package:flutter/material.dart';

final class LoadingScrollPhysic extends ScrollPhysics {
  const LoadingScrollPhysic({super.parent});

  @override
  bool get allowUserScrolling => true;

  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return LoadingScrollPhysic(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    return BouncingScrollSimulation(
      position: position.pixels,
      velocity: velocity,
      leadingExtent: position.minScrollExtent,
      trailingExtent: position.minScrollExtent,
      spring: SpringDescription(mass: 0.2, stiffness: 70, damping: spring.damping),
    );
  }
}
