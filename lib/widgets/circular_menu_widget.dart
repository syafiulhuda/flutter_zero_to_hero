import 'dart:math';

import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zth/data/constants.dart';

class CircularMenuWidget extends StatelessWidget {
  const CircularMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<CircularMenuItem> circularMenuItem = <CircularMenuItem>[
      CircularMenuItem(
        icon: Icons.camera,
        onTap: () {},
        iconColor: KTextStyle.generalColor(context),
        color: KTextStyle.generalTextStyle(context),
      ),
      CircularMenuItem(
        icon: Icons.search,
        onTap: () {},
        iconColor: KTextStyle.generalColor(context),
        color: KTextStyle.generalTextStyle(context),
      ),
      CircularMenuItem(
        icon: Icons.settings,
        onTap: () {},
        iconColor: KTextStyle.generalColor(context),
        color: KTextStyle.generalTextStyle(context),
      ),
      CircularMenuItem(
        icon: Icons.star,
        onTap: () {},
        iconColor: KTextStyle.generalColor(context),
        color: KTextStyle.generalTextStyle(context),
      ),
    ];

    return CircularMenu(
      alignment: Alignment.bottomRight,
      startingAngleInRadian: 0.95 * pi,
      endingAngleInRadian: 1.54 * pi,
      toggleButtonIconColor: KTextStyle.generalTextStyle(context),
      toggleButtonColor: KTextStyle.generalColor(context),
      items: circularMenuItem,
    );
  }
}
