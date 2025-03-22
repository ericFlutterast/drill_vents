import 'package:flutter/material.dart';

class TabBuilder extends StatelessWidget {
  const TabBuilder({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      key: UniqueKey(),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (_, value, __) => Opacity(opacity: value, child: builder.call(context)),
    );
  }
}
