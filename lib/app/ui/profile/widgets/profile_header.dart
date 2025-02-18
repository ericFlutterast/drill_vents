import 'package:cached_network_image/cached_network_image.dart';
import 'package:drill_events/app/ui/widgets/app_icon_button.dart';
import 'package:drill_events/app/ui/widgets/profile_progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final avatarDiameter = 100.0;
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.sizeOf(context).width / 2 - avatarDiameter / 2, right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProfileProgressIndicator(
            diameter: avatarDiameter,
            strokeWidth: 7,
            onTap: () {},
            child: CachedNetworkImage(
              imageUrl: '',
              errorWidget:
                  (_, __, ___) => Container(
                    height: 80,
                    width: 80,
                    decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                  ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppIconButton(icon: CupertinoIcons.pencil, onTap: () {}),
              const SizedBox(height: 13),
              AppIconButton(icon: Icons.settings, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
