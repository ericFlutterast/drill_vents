import 'dart:ui' as ui;

import 'package:drill_events/app/features/widgets/app_bottom_sheet.dart';
import 'package:drill_events/app/themes/app_themes.dart';
import 'package:flutter/material.dart';

class AppModalBottomSheetPage<T> extends Page<T> {
  const AppModalBottomSheetPage({
    required this.child,
    this.isScrollControlled = true,
    this.isDismissible = true,
    this.enableDrag = true,
    this.useSafeArea = false,
    this.elevation,
    this.clipBehavior,
    this.backgroundColor,
    this.anchorPoint,
    this.barrierLabel,
    this.barrierOnTapHint,
    this.capturedThemes,
    this.constraints,
    this.modalBarrierColor,
    this.requestFocus,
    this.shape,
    this.sheetAnimationStyle,
    this.showDragHandle,
    this.transitionAnimationController,
  });

  final Widget child;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final bool isDismissible;
  final Offset? anchorPoint;
  final String? barrierLabel;
  final CapturedThemes? capturedThemes;
  final String? barrierOnTapHint;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final BoxConstraints? constraints;
  final Color? modalBarrierColor;
  final bool enableDrag;
  final bool? showDragHandle;
  final bool? requestFocus;
  final AnimationController? transitionAnimationController;
  final bool useSafeArea;
  final AnimationStyle? sheetAnimationStyle;

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRouteWithBlur<T>(
      settings: this,
      builder: (context) => AppBottomSheet(child: child),
      backgroundColor: backgroundColor ?? context.themes.main.colors.inverse,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useSafeArea: useSafeArea,
      sheetAnimationStyle: sheetAnimationStyle,
      transitionAnimationController: transitionAnimationController,
      requestFocus: requestFocus,
      showDragHandle: showDragHandle,
      modalBarrierColor: modalBarrierColor,
      constraints: constraints,
      clipBehavior: clipBehavior,
      shape:
          shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(36), topRight: Radius.circular(36)),
          ),
      elevation: elevation,
      barrierOnTapHint: barrierOnTapHint,
      anchorPoint: anchorPoint,
    );
  }
}

final class ModalBottomSheetRouteWithBlur<T> extends ModalBottomSheetRoute<T> {
  ModalBottomSheetRouteWithBlur({
    required super.builder,
    required super.isScrollControlled,
    super.settings,
    super.backgroundColor,
    super.isDismissible,
    super.anchorPoint,
    super.barrierLabel,
    super.capturedThemes,
    super.barrierOnTapHint,
    super.elevation,
    super.shape,
    super.clipBehavior,
    super.constraints,
    super.modalBarrierColor,
    super.enableDrag,
    super.showDragHandle,
    super.scrollControlDisabledMaxHeightRatio,
    super.requestFocus,
    super.transitionAnimationController,
    super.useSafeArea,
    super.sheetAnimationStyle,
  });

  @override
  Widget buildModalBarrier() {
    return BackdropFilter(filter: ui.ImageFilter.blur(sigmaY: 2.5, sigmaX: 2.5), child: super.buildModalBarrier());
  }
}
