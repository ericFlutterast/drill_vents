import 'package:flutter/material.dart';

class PaginationScrollPhysic extends ScrollPhysics {
  const PaginationScrollPhysic({super.parent});

  @override
  PaginationScrollPhysic applyTo(ScrollPhysics? ancestor) {
    return PaginationScrollPhysic(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    return BouncingScrollSimulation(
      position: position.pixels,
      velocity: velocity,
      leadingExtent: position.minScrollExtent,
      trailingExtent: position.maxScrollExtent - position.viewportDimension * 0.75,
      spring: SpringDescription(mass: 0.2, stiffness: 150, damping: spring.damping),
    );
  }
}
