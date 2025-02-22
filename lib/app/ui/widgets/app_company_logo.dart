import 'package:flutter/material.dart';

class AppCompanyLogo extends StatelessWidget {
  const AppCompanyLogo({super.key, this.dimension = 52, this.url});

  final double dimension;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 28, spreadRadius: -17, blurStyle: BlurStyle.normal)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          clipBehavior: Clip.hardEdge,
          child: Image.asset('assets/images/image.png'),
          // CachedNetworkImage(
          //   imageUrl: url ?? '',
          //   errorWidget: (_, __, ___) => Image.asset('assets/images/image.png'),
          // ),
        ),
      ),
    );
  }
}
