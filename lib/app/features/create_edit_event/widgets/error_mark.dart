import 'package:drill_events/app/generated/assets.gen.dart';
import 'package:flutter/material.dart';

class ErrorMark extends StatelessWidget {
  const ErrorMark({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSingleChildLayout(delegate: _ErrorMarkDelegate(), child: Assets.icons.errorMark.svg());
  }
}

final class _ErrorMarkDelegate extends SingleChildLayoutDelegate {
  @override
  Size getSize(BoxConstraints constraints) {
    return const Size(7, 7);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(-size.width, childSize.height);
  }

  @override
  bool shouldRelayout(_ErrorMarkDelegate oldDelegate) => false;
}
