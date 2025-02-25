import 'package:flutter/material.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({super.key, this.child, this.borderRadius});

  final Widget? child;

  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const SizedBox(
            height: 4,
            width: 42,
            child: DecoratedBox(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)), color: Color(0xFFEDEDED)),
            ),
          ),

          if (child != null) Flexible(child: child!),
        ],
      ),
    );
  }
}
