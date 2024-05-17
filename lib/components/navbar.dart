import 'dart:ui';

import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BottomNav extends StatefulHookConsumerWidget {
  const BottomNav({super.key, required this.body});

  final Widget Function(BuildContext, ScrollController) body;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav> {
  @override
  Widget build(BuildContext context) {
    Beamer.of(context).addListener(() {
      setState(() {});
    });

    final loc =
        Beamer.of(context).currentBeamLocation.state.routeInformation.uri;
    return BottomBar(
      barColor: Colors.transparent,
      offset: 20,
      borderRadius: const BorderRadius.all(Radius.circular(9999)),
      width: 355,
      body: widget.body,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          backgroundBlendMode: BlendMode.lighten,
          borderRadius: const BorderRadius.all(Radius.circular(9999)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 3,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(9999)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: Image.asset(
                          loc.path.startsWith("/feed")
                              ? "assets/icons/home-color.png"
                              : "assets/icons/home-clay.png",
                          width: 34,
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: loc.path.startsWith("/feed")
                              ? Colors.black
                              : Colors.transparent,
                        ),
                        label: Text(
                          "Home",
                          style: TextStyle(
                            color: loc.path.startsWith("/feed")
                                ? Colors.white
                                : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Image.asset(
                          loc.path.startsWith("/chat")
                              ? "assets/icons/chat-color.png"
                              : "assets/icons/chat-clay.png",
                          width: 34,
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: loc.path.startsWith("/chat")
                              ? Colors.black
                              : Colors.transparent,
                        ),
                        label: Text(
                          "Chats",
                          style: TextStyle(
                            color: loc.path.startsWith("/chat")
                                ? Colors.white
                                : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Image.asset(
                          loc.path.startsWith("/profile")
                              ? "assets/icons/paw-color.png"
                              : "assets/icons/paw-clay.png",
                          width: 34,
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: loc.path.startsWith("/profile")
                              ? Colors.black
                              : Colors.transparent,
                        ),
                        label: Text(
                          "Buddy",
                          style: TextStyle(
                            color: loc.path.startsWith("/profile")
                                ? Colors.white
                                : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
