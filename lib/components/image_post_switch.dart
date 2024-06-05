import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ImagePostSwitch extends StatefulHookConsumerWidget {
  const ImagePostSwitch({
    super.key,
    required this.onImageClick,
    required this.onPostClick,
    this.onGearClick,
  });

  final void Function()? onImageClick;
  final void Function()? onPostClick;
  final void Function()? onGearClick;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ImagePostSwitchState();
}

class _ImagePostSwitchState extends ConsumerState<ImagePostSwitch> {
  bool isPics = true;
  @override
  Widget build(BuildContext context) {
    return Container(
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
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(9999)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6),
          color: Colors.white.withOpacity(0.8),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      widget.onImageClick?.call();
                      setState(() {
                        isPics = true;
                      });
                    },
                    icon: Image.asset(
                      isPics
                          ? "assets/icons/camera-front-color.png"
                          : "assets/icons/camera-front-clay.png",
                      width: 34,
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor:
                          isPics ? Colors.black : Colors.transparent,
                    ),
                    label: Text(
                      "Pics",
                      style: TextStyle(
                        color: isPics ? Colors.white : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      widget.onPostClick?.call();
                      setState(() {
                        isPics = false;
                      });
                    },
                    icon: Image.asset(
                      !isPics
                          ? "assets/icons/notify-heart-front-color.png"
                          : "assets/icons/notify-heart-front-clay.png",
                      width: 34,
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor:
                          !isPics ? Colors.black : Colors.transparent,
                    ),
                    label: Text(
                      "Posts",
                      style: TextStyle(
                        color: !isPics ? Colors.white : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (widget.onGearClick != null) ...[
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: widget.onGearClick,
                    icon: SvgPicture.asset(
                      "assets/icons/gear-duotone.svg",
                      width: 20,
                      height: 20,
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
