import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppCompanyLogo extends StatelessWidget {
  const AppCompanyLogo({super.key, this.dimension = 52, this.url, this.onTap});

  final double dimension;
  final String? url;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: dimension,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Color(0x14000000), blurRadius: 28, spreadRadius: 0, blurStyle: BlurStyle.normal),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            clipBehavior: Clip.hardEdge,
            child: FittedBox(
              fit: BoxFit.cover,
              child: CachedNetworkImage(
                imageUrl: url ?? '',
                errorWidget: (_, __, ___) => Image.asset('assets/images/image.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
