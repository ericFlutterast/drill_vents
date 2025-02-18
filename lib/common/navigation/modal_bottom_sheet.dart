import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class AppModalBottomSheetPage<T> extends Page<T> {
  const AppModalBottomSheetPage({required this.child});

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRouteWithBlur<T>(
      settings: this,
      builder: (context) {
        return child;
      },
      backgroundColor: Colors.white,
      isScrollControlled: true,
    );
  }
}

final class ModalBottomSheetRouteWithBlur<T> extends ModalBottomSheetRoute<T> {
  ModalBottomSheetRouteWithBlur({
    required super.builder,
    required super.isScrollControlled,
    super.settings,
    super.backgroundColor,
  });

  @override
  Widget buildModalBarrier() {
    return BackdropFilter(filter: ui.ImageFilter.blur(sigmaY: 2.5, sigmaX: 2.5), child: super.buildModalBarrier());
  }
}
