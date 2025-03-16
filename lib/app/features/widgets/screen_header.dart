import 'package:drill_events/app/features/widgets/app_back_button.dart';
import 'package:drill_events/app/features/widgets/app_company_logo.dart';
import 'package:drill_events/app/features/widgets/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class PositionedScreenHeader extends StatelessWidget {
  const PositionedScreenHeader({
    super.key,
    this.controller,
    this.backButtonHandler,
    this.onTapLogo,
    this.isPending = false,
    this.actions,
  });

  final bool isPending;
  final VoidCallback? onTapLogo, backButtonHandler;
  final ScrollController? controller;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 5 + MediaQuery.sizeOf(context).height * 0.1,
      left: 0,
      right: 0,
      child: ScreenHeader(
        controller: controller,
        onTapLogo: onTapLogo,
        backButtonHandler: backButtonHandler,
        isPending: isPending,
        actions: actions ?? [],
      ),
    );
  }
}

// TODO: Из-за BouncingScrollPhysics есть бага, при offset = 0 - контролы не появляются
class ScreenHeader extends StatefulWidget {
  const ScreenHeader({
    super.key,
    this.controller,
    this.backButtonHandler,
    this.onTapLogo,
    this.isPending = false,
    required this.actions,
  });

  final bool isPending;
  final VoidCallback? onTapLogo, backButtonHandler;
  final ScrollController? controller;
  final List<Widget> actions;

  @override
  State<ScreenHeader> createState() => _ScreenHeaderState();
}

class _ScreenHeaderState extends State<ScreenHeader> with TickerProviderStateMixin {
  late final AnimationController _buttonAnimationController;
  late final Animation<Offset> _buttonOffsetAnimation;

  late final AnimationController _controlsAnimationController;
  late final Animation<Offset> _controlsOffsetAnimation;

  static const _animationDuration = Duration(milliseconds: 600);
  static const _scrollThreshold = 60;

  @override
  void initState() {
    super.initState();

    _buttonAnimationController = AnimationController(duration: _animationDuration, vsync: this);

    final buttonController = CurvedAnimation(parent: _buttonAnimationController, curve: Curves.fastEaseInToSlowEaseOut);
    final buttonTween = Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-2, 0));
    _buttonOffsetAnimation = buttonTween.animate(buttonController);

    _controlsAnimationController = AnimationController(duration: _animationDuration, vsync: this);

    final controlsController = CurvedAnimation(
      parent: _controlsAnimationController,
      curve: Curves.fastEaseInToSlowEaseOut,
    );
    final controlsTween = Tween<Offset>(begin: const Offset(0, 0), end: const Offset(2, 0));
    _controlsOffsetAnimation = controlsTween.animate(controlsController);

    widget.controller?.addListener(_runAnimation);
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    widget.controller?.removeListener(_runAnimation);
    super.dispose();
  }

  void _runAnimation() {
    if (_buttonAnimationController.status.isAnimating) return;

    // It's safe, since this method is called only if controller is passed
    final position = widget.controller!.position;
    final (offset, direction) = (position.pixels, position.userScrollDirection);

    if (direction == ScrollDirection.forward) {
      _buttonAnimationController.reverse();
      if (offset <= _scrollThreshold) {
        _controlsAnimationController.reverse();
      }
    } else if (direction == ScrollDirection.reverse && offset > _scrollThreshold) {
      _buttonAnimationController.forward();
      _controlsAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPending) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppBackButton(onTap: () => Navigator.pop(context)),
            const Shimmer(height: 52, width: 52, borderRadius: 50),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SlideTransition(
            position: _buttonOffsetAnimation,
            child: AppBackButton(onTap: widget.backButtonHandler ?? () => Navigator.pop(context)),
          ),

          SlideTransition(
            position: _controlsOffsetAnimation,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [if (widget.onTapLogo != null) AppCompanyLogo(onTap: widget.onTapLogo), ...widget.actions],
            ),
          ),
        ],
      ),
    );
  }
}
