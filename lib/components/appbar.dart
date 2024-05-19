import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarBuddy extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBuddy({
    super.key,
    this.actions,
  });

  final List<Widget>? actions;

  @override
  Size get preferredSize {
    return const Size.fromHeight(65);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      toolbarHeight: 65,
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 16,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Image.asset(
          "assets/icons/logo.png",
          height: 50,
        ),
      ),
      actions: actions ??
          [
            IconButton(
              onPressed: () {},
              icon: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(4.0),
                child: SvgPicture.asset(
                  "assets/icons/rectangle-history-circle-plus-duotone.svg",
                  width: 26,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(4.0),
                child: SvgPicture.asset(
                  "assets/icons/search.svg",
                  width: 24,
                ),
              ),
            ),
          ],
    );
  }
}
