import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewPost extends HookConsumerWidget {
  const NewPost({super.key, required this.onPost, required this.onImage});

  final void Function()? onPost;
  final void Function()? onImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      bottom: true,
      top: false,
      child: SizedBox(
        height: 300,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onImage,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 231, 231, 230),
                        Color(0xFFE7E6E6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  margin: const EdgeInsets.only(
                      top: 8, right: 4, bottom: 8, left: 8),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Inverted color assets/icons/camera-front-clay.png

                      Image.asset(
                        "assets/icons/camera-front-color.png",
                        width: 50,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Post Image",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: onPost,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 63, 63, 63),
                        Color.fromARGB(255, 0, 0, 0),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  margin: const EdgeInsets.only(
                      top: 8, right: 8, bottom: 8, left: 4),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/notify-heart-front-clay.png",
                        width: 50,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Post Text",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
