import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class ShoppingBag extends StatelessWidget {
  const ShoppingBag({
    super.key,
    this.color,
    this.numOfItem,
    this.press,
  });

  final Color? color;
  final int? numOfItem;

  /// Tap handler; the button was previously hardcoded to do nothing.
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: press,
      icon: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            numOfItem == null
                ? "assets/icons/Bag.svg"
                : "assets/icons/bag_full.svg",
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
                color ?? Theme.of(context).iconTheme.color!, BlendMode.srcIn),
          ),
          if (numOfItem != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                numOfItem!.toString(),
                style: TextStyle(
                  fontFamily: grandisExtendedFont,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? blackColor
                      : Colors.white,
                ),
              ),
            )
        ],
      ),
    );
  }
}
