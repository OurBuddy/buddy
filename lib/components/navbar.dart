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
  listenFunc() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Beamer.of(context).removeListener(listenFunc);
    Beamer.of(context).addListener(listenFunc);
    final loc =
        Beamer.of(context).currentBeamLocation.state.routeInformation.uri;
    return BottomBar(
      barColor: Colors.transparent,
      offset: 20,
      borderRadius: const BorderRadius.all(Radius.circular(9999)),
      width: 355,
      body: widget.body,
      icon: (width, height) {
        return const CircleAvatar(
          backgroundColor: Colors.black,
          child: Icon(
            Icons.keyboard_arrow_up_rounded,
            size: 30,
            color: Colors.white,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(9999)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Hero(
          tag: "bottom-nav",
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(9999)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(4.0),
                color: Colors.white.withOpacity(0.8),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Beamer.of(context).beamToNamed("/feed");
                        },
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
                        onPressed: () {
                          Beamer.of(context).beamToNamed("/chat");
                        },
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
                        onPressed: () {
                          Beamer.of(context).beamToNamed("/profile");
                        },
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
